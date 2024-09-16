//
//  RideNRowTests.swift
//
//
//  Created by Alsey Coleman Miller  on 9/15/24.
//

import Foundation
import XCTest
import Bluetooth
#if canImport(BluetoothGAP)
import BluetoothGAP
#endif
import GATT
@testable import SunnyFit

final class RideNRowTests: XCTestCase {
    
    func testRideNRowAdvertisement() throws {
        
        /*
         Sep 15 21:16:07.281  HCI Event        0x0000  30:1B:97:BC:FE:AE  LE - Ext ADV - 1 Report - Normal - Public - 30:1B:97:BC:FE:AE  -96 dBm - NO. 077 SMART-H - Channel 37
             Parameter Length: 49 (0x31)
             Num Reports: 0X01
             Report 0
                 Event Type: Connectable Advertising - Scannable Advertising - Legacy Advertising PDUs Used - Complete -
                 Address Type: Public
                 Peer Address: 30:1B:97:BC:FE:AE
                 Primary PHY: 1M
                 Secondary PHY: No Packets
                 Advertising SID: Unavailable
                 Tx Power: Unavailable
                 RSSI: -96 dBm
                 Periodic Advertising Interval: 0.000000ms (0x0)
                 Direct Address Type: Public
                 Direct Address: 00:00:00:00:00:00
                 Data Length: 23
                 Local Name: NO. 077 SMART-H
                 Data: 05 16 01 00 05 00 10 09 4E 4F 2E 20 30 37 37 20 53 4D 41 52 54 2D 48
         */
        
        let advertismentData: LowEnergyAdvertisingData = [0x05, 0x16, 0x01, 0x00, 0x05, 0x00, 0x10, 0x09, 0x4E, 0x4F, 0x2E, 0x20, 0x30, 0x37, 0x37, 0x20, 0x53, 0x4D, 0x41, 0x52, 0x54, 0x2D, 0x48]
        
        guard let name = advertismentData.localName,
              let serviceData = advertismentData.serviceData else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(name, SunnyFitAccessoryType.rowNRideUpright.rawValue)
        XCTAssertEqual(serviceData[.bit16(0x0001)], Data([0x05, 0x00]))
        
        /*
         Sep 15 21:24:14.054  HCI Event        0x0000  30:1B:97:BC:FE:AE  LE - Ext ADV - 1 Report - Normal - Public - 30:1B:97:BC:FE:AE  -68 dBm - Manufacturer Specific Data - Channel 37
             Parameter Length: 49 (0x31)
             Num Reports: 0X01
             Report 0
                 Event Type: Connectable Advertising - Scannable Advertising - Scan Response - Legacy Advertising PDUs Used - Complete -
                 Address Type: Public
                 Peer Address: 30:1B:97:BC:FE:AE
                 Primary PHY: 1M
                 Secondary PHY: No Packets
                 Advertising SID: Unavailable
                 Tx Power: Unavailable
                 RSSI: -68 dBm
                 Periodic Advertising Interval: 0.000000ms (0x0)
                 Direct Address Type: Public
                 Direct Address: 00:00:00:00:00:00
                 Data Length: 23
                 Flags: 0x6
                     LE Limited General Discoverable Mode
                     BR/EDR Not Supported
                 Data: 02 01 06 13 FF 5A 00 00 30 1B 97 BC FE AE 7A 00 00 00 00 00 00 00 C4
         */
        
        let scanResponse: LowEnergyAdvertisingData = [0x02, 0x01, 0x06, 0x13, 0xFF, 0x5A, 0x00, 0x00, 0x30, 0x1B, 0x97, 0xBC, 0xFE, 0xAE, 0x7A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xC4]
        
        guard let manufacturerData = scanResponse.manufacturerData else {
            XCTFail()
            return
        }
        
        /// https://www.emmicroelectronic.com/about
        /// Along with Renata and Micro Crysta,l EM makes up the Electronic Systems Segment of the Swatch Group.
        XCTAssertEqual(manufacturerData.companyIdentifier, .emMicroelectronicMarin)
        
        // parse address
        let address = BluetoothAddress(bigEndian: BluetoothAddress(data: Data(manufacturerData.additionalData[1 ..< 7]))!)
        XCTAssertEqual(address.description, "30:1B:97:BC:FE:AE")
        
        guard let accessory = SunnyFitAccessory(name: name, manufacturerData: manufacturerData) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(accessory.id, address)
        XCTAssertEqual(accessory.type, .rowNRideUpright)
    }
}
