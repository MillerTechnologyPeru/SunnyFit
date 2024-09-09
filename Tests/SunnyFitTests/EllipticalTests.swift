//
//  EllipticalTests.swift
//
//
//  Created by Alsey Coleman Miller on 9/8/24.
//

import Foundation
import XCTest
import Bluetooth
#if canImport(BluetoothGAP)
import BluetoothGAP
#endif
import GATT
@testable import SunnyFit

final class EllipticalTests: XCTestCase {
    
    func testEllipticalAdvertisement() throws {
        
        /*
         Sep 08 21:36:15.205  HCI Event        0x0000  A4:C1:38:4D:67:F8  LE - Ext ADV - 1 Report - Normal - Public - A4:C1:38:4D:67:F8  -75 dBm - SF-E902 SMART-H - Channel 37  RECV
             Parameter Length: 53 (0x35)
             Num Reports: 0X01
             Report 0
                 Event Type: Connectable Advertising - Scannable Advertising - Legacy Advertising PDUs Used - Complete -
                 Address Type: Public
                 Peer Address: A4:C1:38:4D:67:F8
                 Primary PHY: 1M
                 Secondary PHY: No Packets
                 Advertising SID: Unavailable
                 Tx Power: Unavailable
                 RSSI: -75 dBm
                 Periodic Advertising Interval: 0.000000ms (0x0)
                 Direct Address Type: Public
                 Direct Address: 00:00:00:00:00:00
                 Data Length: 27
                 Flags: 0x6
                     LE Limited General Discoverable Mode
                     BR/EDR Not Supported
                 Local Name: SF-E902 SMART-H
                 Data: 02 01 06 06 16 26 18 01 02 00 10 09 53 46 2D 45 39 30 32 20 53 4D 41 52 54 2D 48
         */
        
        let advertismentData: LowEnergyAdvertisingData = [0x02, 0x01, 0x06, 0x06, 0x16, 0x26, 0x18, 0x01, 0x02, 0x00, 0x10, 0x09, 0x53, 0x46, 0x2D, 0x45, 0x39, 0x30, 0x32, 0x20, 0x53, 0x4D, 0x41, 0x52, 0x54, 0x2D, 0x48]
        
        guard let name = advertismentData.localName,
              let serviceData = advertismentData.serviceData else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(name, SunnyFitAccessoryType.ellipticalAirWalk.rawValue)
        XCTAssertEqual(serviceData[.bit16(0x1826)], Data([0x01, 0x02, 0x00])) // FTMS profile
        
        /*
         Sep 08 21:36:15.205  HCI Event        0x0000  A4:C1:38:4D:67:F8  LE - Ext ADV - 1 Report - Normal - Public - A4:C1:38:4D:67:F8  -76 dBm - Manufacturer Specific Data - Channel 37  RECV
             Parameter Length: 34 (0x22)
             Num Reports: 0X01
             Report 0
                 Event Type: Connectable Advertising - Scannable Advertising - Scan Response - Legacy Advertising PDUs Used - Complete -
                 Address Type: Public
                 Peer Address: A4:C1:38:4D:67:F8
                 Primary PHY: 1M
                 Secondary PHY: No Packets
                 Advertising SID: Unavailable
                 Tx Power: Unavailable
                 RSSI: -76 dBm
                 Periodic Advertising Interval: 0.000000ms (0x0)
                 Direct Address Type: Public
                 Direct Address: 00:00:00:00:00:00
                 Data Length: 8
                 Data: 07 FF F8 67 4D 38 C1 A4
         */
        
        let scanResponse: LowEnergyAdvertisingData = [0x07, 0xFF, 0xF8, 0x67, 0x4D, 0x38, 0xC1, 0xA4]
        
        guard let manufacturerData = scanResponse.manufacturerData else {
            XCTFail()
            return
        }
                
        // parse address
        let companyBytes = manufacturerData.companyIdentifier.rawValue.littleEndian.bytes
        let address = BluetoothAddress(littleEndian: BluetoothAddress(bytes: (companyBytes.0, companyBytes.1, manufacturerData.additionalData[0], manufacturerData.additionalData[1], manufacturerData.additionalData[2], manufacturerData.additionalData[3])))
        XCTAssertEqual(address.description, "A4:C1:38:4D:67:F8")
        
        guard let accessory = SunnyFitAccessory(name: name, manufacturerData: manufacturerData) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(accessory.id, address)
        XCTAssertEqual(accessory.type, .ellipticalAirWalk)
    }
}
