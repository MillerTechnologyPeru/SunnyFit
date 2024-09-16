//
//  SunnyFitDetailView.swift
//  
//
//  Created by Alsey Coleman Miller on 9/8/24.
//

import Foundation
import SwiftUI
import Bluetooth
import GATT
import SunnyFit

struct SunnyFitAccessoryDetailView: View {
    
    let accessory: SunnyFitAccessory
    
    @EnvironmentObject
    private var store: AccessoryManager
    
    @State
    private var reloadTask: Task<Void, Never>?
    
    @State
    private var error: String?
    
    @State
    private var isReloading = false
    
    @State
    private var information: Result<SunnyFitAccessoryInfo, Error>?
    
    @State
    private var services = [ServiceSection]()
    
    init(
        accessory: SunnyFitAccessory
    ) {
        self.accessory = accessory
    }
    
    var body: some View {
        VStack {
            StateView(
                accessory: accessory,
                information: information,
                services: services
            )
        }
        .refreshable {
            reload()
        }
        .onAppear {
            reload()
        }
        .onDisappear {
            reloadTask?.cancel()
        }
    }
}

extension SunnyFitAccessoryDetailView {
    
    func reload() {
        let store = self.store
        let characteristicsTask = Task {
            // read characteristics
            if let peripheral, services.isEmpty {
                try await store.central.connection(for: peripheral) { connection in
                    try await readCharacteristics(connection: connection)
                }
            }
        }
        let accessoryMetadataTask = Task {
            // accessory metadata
            if let accessoryInfo = store.accessoryInfo {
                self.information = accessoryInfo[accessory.type].flatMap { .success($0) }
            } else {
                // load accessory info
                await fetchAccessoryInfo()
            }
        }
        // networking and Bluetooth
        isReloading = true
        reloadTask = Task(priority: .userInitiated) {
            defer { isReloading = false }
            await accessoryMetadataTask.value
            try? await characteristicsTask.value
        }
    }
    
    func fetchAccessoryInfo() async {
        do {
            // fetch info from DB
            let accessoryInfo = try await store.downloadAccessoryInfo()
            self.information = accessoryInfo[accessory.type]
                .flatMap { .success($0) } ?? .failure(CocoaError(.coderValueNotFound))
        }
        catch {
            self.information = .failure(error)
        }
    }
    
    func disconnect() {
        Task {
            await store.disconnect(accessory.id)
        }
    }
    
    var peripheral: NativePeripheral? {
        store[peripheral: accessory.id]
    }
    
    var isConnected: Bool {
        guard let peripheral else {
            return false
        }
        return store.connections.contains(peripheral)
    }
}

extension SunnyFitAccessoryDetailView {
    
    struct StateView: View {
        
        let accessory: SunnyFitAccessory
        
        let information: Result<SunnyFitAccessoryInfo, Error>?
        
        let services: [ServiceSection]
        
        var body: some View {
            ScrollView {
                VStack(spacing: 16) {
                    // image view
                    VStack {
                        switch information {
                        case .success(let success):
                            CachedAsyncImage(
                                url: URL(string: success.image),
                                content: { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }, placeholder: {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                })
                        case .failure(let failure):
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.yellow)
                            Text(verbatim: failure.localizedDescription)
                        case nil:
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                    }
                    .frame(height: 250)
                    .padding()
                    
                    // Actions
                    switch accessory.type {
                    case .stepperMini, 
                        .rowNRideUpright:
                        NavigationLink(destination: {
                            StepperView(accessory: accessory)
                        }, label: {
                            Text("Start Exercise")
                        })
                    default:
                        EmptyView()
                    }
                    
                    // Links
                    if let information = try? information?.get() {
                        if let manual = information.manual.flatMap({ URL(string: $0) }) {
                            Link("User Manual", destination: manual)
                        }
                        if let website = information.website.flatMap({ URL(string: $0) }) {
                            Link("Product Page", destination: website)
                        }
                    }
                    
                    // GATT Device Information
                    ForEach(services) { service in
                        Section(service.name) {
                            ForEach(service.characteristics) { characteristic in
                                SubtitleRow(
                                    title: Text(characteristic.name),
                                    subtitle: Text(verbatim: characteristic.value)
                                )
                            }
                        }
                    }
                }
            }
            .navigationTitle("\(accessory.type.rawValue)")
        }
    }
}

extension SunnyFitAccessoryDetailView {
    
    func readCharacteristics(connection: GATTConnection<NativeCentral>) async throws {
        
        var batteryService = ServiceSection(
            id: .batteryService,
            name: "Battery Service",
            characteristics: []
        )
        
        // read battery level
        if let characteristic = connection.cache.characteristic(.batteryLevel, service: .batteryService) {
            let data = try await connection.central.readValue(for: characteristic)
            guard data.count == 1 else {
                throw SunnyFitAppError.invalidCharacteristicValue(.batteryLevel)
            }
            let value = data[0]
            batteryService.characteristics.append(
                CharacteristicItem(
                    id: characteristic.uuid.rawValue,
                    name: "Battery Level",
                    value: "\(value)%"
                )
            )
        }
        
        // read device information
        var deviceInformationService = ServiceSection(
            id: .deviceInformation,
            name: "Device Information",
            characteristics: []
        )
        if let characteristic = connection.cache.characteristic(.manufacturerNameString, service: .deviceInformation) {
            let data = try await connection.central.readValue(for: characteristic)
            guard let value = String(data: data, encoding: .utf8) else {
                throw SunnyFitAppError.invalidCharacteristicValue(.manufacturerNameString)
            }
            deviceInformationService.characteristics.append(
                CharacteristicItem(
                    id: BluetoothUUID.manufacturerNameString.rawValue,
                    name: "Manufacturer Name",
                    value: value
                )
            )
        }
        if let characteristic = connection.cache.characteristic(.modelNumberString, service: .deviceInformation) {
            let data = try await connection.central.readValue(for: characteristic)
            guard let value = String(data: data, encoding: .utf8) else {
                throw SunnyFitAppError.invalidCharacteristicValue(.modelNumberString)
            }
            deviceInformationService.characteristics.append(
                CharacteristicItem(
                    id: BluetoothUUID.modelNumberString.rawValue,
                    name: "Model",
                    value: value
                )
            )
        }
        if let characteristic = connection.cache.characteristic(.serialNumberString, service: .deviceInformation) {
            let data = try await connection.central.readValue(for: characteristic)
            guard let value = String(data: data, encoding: .utf8) else {
                throw SunnyFitAppError.invalidCharacteristicValue(.serialNumberString)
            }
            deviceInformationService.characteristics.append(
                CharacteristicItem(
                    id: BluetoothUUID.serialNumberString.rawValue,
                    name: "Serial Number",
                    value: value
                )
            )
        }
        if let characteristic = connection.cache.characteristic(.firmwareRevisionString, service: .deviceInformation) {
            let data = try await connection.central.readValue(for: characteristic)
            guard let value = String(data: data, encoding: .utf8) else {
                throw SunnyFitAppError.invalidCharacteristicValue(.firmwareRevisionString)
            }
            deviceInformationService.characteristics.append(
                CharacteristicItem(
                    id: BluetoothUUID.firmwareRevisionString.rawValue,
                    name: "Firmware Revision",
                    value: value
                )
            )
        }
        if let characteristic = connection.cache.characteristic(.hardwareRevisionString, service: .deviceInformation) {
            let data = try await connection.central.readValue(for: characteristic)
            guard let value = String(data: data, encoding: .utf8) else {
                throw SunnyFitAppError.invalidCharacteristicValue(.hardwareRevisionString)
            }
            deviceInformationService.characteristics.append(
                CharacteristicItem(
                    id: BluetoothUUID.hardwareRevisionString.rawValue,
                    name: "Hardware Revision",
                    value: value
                )
            )
        }
        if let characteristic = connection.cache.characteristic(.softwareRevisionString, service: .deviceInformation) {
            let data = try await connection.central.readValue(for: characteristic)
            guard let value = String(data: data, encoding: .utf8) else {
                throw SunnyFitAppError.invalidCharacteristicValue(.softwareRevisionString)
            }
            deviceInformationService.characteristics.append(
                CharacteristicItem(
                    id: BluetoothUUID.softwareRevisionString.rawValue,
                    name: "Software Revision",
                    value: value
                )
            )
        }
        
        // set services
        self.services = [
            batteryService,
            deviceInformationService
        ]
        .filter { $0.characteristics.isEmpty == false }
    }
}

extension SunnyFitAccessoryDetailView {
    
    struct ServiceSection: Equatable, Identifiable {
        
        let id: BluetoothUUID
        
        let name: LocalizedStringKey
        
        var characteristics: [CharacteristicItem]
    }
    
    struct CharacteristicItem: Equatable, Identifiable {
        
        let id: String
        
        let name: LocalizedStringKey
        
        let value: String
    }
}
