//
//  MockAdvertisement.swift
//
//
//  Created by Alsey Coleman Miller on 9/8/24.
//

#if DEBUG
import Foundation
import Bluetooth
import GATT
import SunnyFit

/// Mock Advertisement Data
public struct MockAdvertisementData: AdvertisementData {
    
    /// The local name of a peripheral.
    public let localName: String?
    
    /// The Manufacturer data of a peripheral.
    public let manufacturerData: ManufacturerSpecificData?
    
    /// This value is available if the broadcaster (peripheral) provides its Tx power level in its advertising packet.
    /// Using the RSSI value and the Tx power level, it is possible to calculate path loss.
    public let txPowerLevel: Double?
    
    /// Service-specific advertisement data.
    public let serviceData: [BluetoothUUID: Data]?
    
    /// An array of service UUIDs
    public let serviceUUIDs: [BluetoothUUID]?
    
    /// An array of one or more `BluetoothUUID`, representing Service UUIDs.
    public let solicitedServiceUUIDs: [BluetoothUUID]?
    
    internal init(
        localName: String? = nil,
        manufacturerData: ManufacturerSpecificData? = nil,
        txPowerLevel: Double? = nil,
        serviceData: [BluetoothUUID : Data]? = nil,
        serviceUUIDs: [BluetoothUUID]? = nil,
        solicitedServiceUUIDs: [BluetoothUUID]? = nil
    ) {
        
        self.localName = localName
        self.manufacturerData = manufacturerData
        self.txPowerLevel = txPowerLevel
        self.serviceData = serviceData
        self.serviceUUIDs = serviceUUIDs
        self.solicitedServiceUUIDs = solicitedServiceUUIDs
    }
}

public extension MockAdvertisementData {
    
    static let beacon = MockAdvertisementData(
        localName: nil,
        manufacturerData: ManufacturerSpecificData(data: Data([0x4c, 0x00, 0x02, 0x15, 0xb9, 0x40, 0x7f, 0x30, 0xf5, 0xf8, 0x46, 0x6e, 0xaf, 0xf9, 0x25, 0x55, 0x6b, 0x57, 0xfe, 0x6d, 0x29, 0x4c, 0x90, 0x39, 0x74])),
        txPowerLevel: nil,
        serviceData: nil,
        serviceUUIDs: nil,
        solicitedServiceUUIDs: nil
    )
    
    static let savantThermostat = MockAdvertisementData(
        localName: "CLI-W200",
        manufacturerData: ManufacturerSpecificData(data: Data([0xd9, 0x01, 0x01, 0x02, 0x00, 0x00, 0x8c, 0x85, 0x90, 0xcb, 0x31, 0x74, 0x00, 0x60])),
        txPowerLevel: nil,
        serviceData: nil,
        serviceUUIDs: [.savantSystems2],
        solicitedServiceUUIDs: nil
    )
}

#endif
