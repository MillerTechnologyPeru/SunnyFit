//
//  AccessoryManagerBluetooth.swift
//  
//
//  Created by Alsey Coleman Miller on 9/8/24.
//

import Foundation
import Bluetooth
import GATT
import DarwinGATT
import SunnyFit

public extension AccessoryManager {
    
    /// The Bluetooth LE peripheral for the speciifed device identifier..
    subscript (peripheral id: SunnyFitAccessory.ID) -> NativeCentral.Peripheral? {
        return peripherals.first(where: { $0.value.id == id })?.key
    }
    
    func scan(duration: TimeInterval? = nil) async throws {
        let bluetoothState = await central.state
        guard bluetoothState == .poweredOn else {
            throw SunnyFitAppError.bluetoothUnavailable
        }
        let filterDuplicates = true //preferences.filterDuplicates
        self.peripherals.removeAll(keepingCapacity: true)
        stopScanning()
        let scanStream = try await central.scan(
            filterDuplicates: filterDuplicates
        )
        self.scanStream = scanStream
        let task = Task { [unowned self] in
            for try await scanData in scanStream {
                guard await found(scanData) else { continue }
            }
        }
        if let duration = duration {
            precondition(duration > 0.001)
            try await Task.sleep(timeInterval: duration)
            scanStream.stop()
            try await task.value // throw errors
        } else {
            // error not thrown
            Task { [unowned self] in
                do { try await task.value }
                catch is CancellationError { }
                catch {
                    self.log("Error scanning: \(error)")
                }
            }
        }
    }
    
    func stopScanning() {
        scanStream?.stop()
        scanStream = nil
    }
    
    @discardableResult
    func connect(to accessory: SunnyFitAccessory.ID) async throws -> GATTConnection<NativeCentral> {
        let central = self.central
        guard let peripheral = self[peripheral: accessory] else {
            throw CentralError.unknownPeripheral
        }
        if let connection = self.connectionsByPeripherals[peripheral] {
            return connection
        }
        // connect
        if await loadConnections.contains(peripheral) == false {
            // initiate connection
            try await central.connect(to: peripheral)
        }
        // cache MTU
        let maximumTransmissionUnit = try await central.maximumTransmissionUnit(for: peripheral)
        // get characteristics by UUID
        let servicesCache = try await central.cacheServices(for: peripheral)
        let connectionCache = GATTConnection(
            central: central,
            peripheral: peripheral,
            maximumTransmissionUnit: maximumTransmissionUnit,
            cache: servicesCache
        )
        // store connection cache
        self.connectionsByPeripherals[peripheral] = connectionCache
        return connectionCache
    }
    
    func disconnect(_ accessory: SunnyFitAccessory.ID) async {
        guard let peripheral = self[peripheral: accessory] else {
            assertionFailure()
            return
        }
        // stop notifications
        await central.disconnect(peripheral)
    }
    
    /// Recieve Stepper values.
    func startStepper(
        for accessory: SunnyFitAccessory.ID
    ) async throws -> AsyncIndefiniteStream<SunnyFitNotification> {
        let connection = try await connect(to: accessory)
        return try await connection.startStepper()
    }
}

internal extension GATTConnection {
    
    func startStepper() async throws -> AsyncIndefiniteStream<SunnyFitNotification> {
        guard let commandCharacteristic = cache.characteristic(.sunnyFitCommandCharacteristic, service: .sunnyFitService) else {
            throw SunnyFitAppError.characteristicNotFound(.sunnyFitCommandCharacteristic)
        }
        guard let commandCharacteristic2 = cache.characteristic(.sunnyFitCommandCharacteristic2, service: .sunnyFitService) else {
            throw SunnyFitAppError.characteristicNotFound(.sunnyFitCommandCharacteristic2)
        }
        guard let notificationCharacteristic = cache.characteristic(.sunnyFitNotificationCharacteristic, service: .sunnyFitService) else {
            throw SunnyFitAppError.characteristicNotFound(.sunnyFitNotificationCharacteristic)
        }
        guard let notificationCharacteristic2 = cache.characteristic(.sunnyFitNotificationCharacteristic2, service: .sunnyFitService) else {
            throw SunnyFitAppError.characteristicNotFound(.sunnyFitNotificationCharacteristic2)
        }
        guard let notificationCharacteristic3 = cache.characteristic(.sunnyFitNotificationCharacteristic3, service: .sunnyFitService) else {
            throw SunnyFitAppError.characteristicNotFound(.sunnyFitNotificationCharacteristic3)
        }
        let notifications1 = try await central.notify(for: notificationCharacteristic)
        Task {
            for try await data in notifications1 {
                print(data.toHexadecimal())
            }
        }
        let notifications2 = try await central.notify(for: notificationCharacteristic2)
        Task {
            for try await data in notifications2 {
                print(data.toHexadecimal())
            }
        }
        let notifications3 = try await central.sunnyFitStatus(characteristic: notificationCharacteristic3)

        // send start command
        let command1 = Data([0x5A, 0x02, 0x00, 0x08, 0x07, 0xA0, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0xE6, 0xA5])
        try await central.writeValue(command1, for: commandCharacteristic, withResponse: false)
        try await Task.sleep(timeInterval: 0.5)
        let command2 = Data([0x5A, 0x01, 0x00, 0x00, 0x01, 0xA5])
        try await central.writeValue(command2, for: commandCharacteristic, withResponse: false)
        try await Task.sleep(timeInterval: 0.5)
        let command3 = Data([0x5A, 0x02, 0x00, 0x03, 0x02, 0xA3, 0x00, 0xAA, 0xA5])
        try await central.writeValue(command3, for: commandCharacteristic, withResponse: false)
        try await Task.sleep(timeInterval: 0.5)
        
        
        let command4 = Data([0x5A, 0x04, 0x00, 0x00, 0x04, 0xA5])
        try await central.writeValue(command4, for: commandCharacteristic2, withResponse: false)
        return notifications3
    }
}

internal extension AccessoryManager {
    
    func observeBluetoothState() {
        // observe state
        Task { [weak self] in
            while let self = self {
                let newState = await self.central.state
                let oldValue = self.state
                if newState != oldValue {
                    self.state = newState
                }
                try await Task.sleep(timeInterval: 0.5)
            }
        }
        // observe connections
        Task { [weak self] in
            while let self = self {
                let newState = await self.loadConnections
                let oldValue = self.connections
                let disconnected = self.connectionsByPeripherals
                    .filter { newState.contains($0.value.peripheral) }
                    .keys
                if newState != oldValue, disconnected.isEmpty == false {
                    for peripheral in disconnected {
                        self.connectionsByPeripherals[peripheral] = nil
                    }
                }
                try await Task.sleep(timeInterval: 0.2)
            }
        }
    }
    
    var loadConnections: Set<NativePeripheral> {
        get async {
            let peripherals = await self.central
                .peripherals
                .filter { $0.value }
                .map { $0.key }
            return Set(peripherals)
        }
    }
    
    func found(_ scanData: ScanData<NativeCentral.Peripheral, NativeCentral.Advertisement>) async -> Bool {
        
        // aggregate scan data
        assert(Thread.isMainThread)
        let oldCacheValue = scanResults[scanData.peripheral]
        // cache discovered peripheral in background
        let cache = await Task.detached { [weak central] in
            assert(Thread.isMainThread == false)
            var cache = oldCacheValue ?? ScanDataCache(scanData: scanData)
            cache += scanData
            #if canImport(CoreBluetooth)
            cache.name = try? await central?.name(for: scanData.peripheral)
            for serviceUUID in scanData.advertisementData.overflowServiceUUIDs ?? [] {
                cache.overflowServiceUUIDs.insert(serviceUUID)
            }
            #endif
            return cache
        }.value
        scanResults[scanData.peripheral] = cache
        assert(Thread.isMainThread)
        
        // cache identified accessory
        if let name = cache.name,
           let manufacturerData = cache.manufacturerData,
           let accessory = SunnyFitAccessory(name: name, manufacturerData: manufacturerData) {
            self.peripherals[scanData.peripheral] = accessory
            return true
        } else {
            return false
        }
    }
}
