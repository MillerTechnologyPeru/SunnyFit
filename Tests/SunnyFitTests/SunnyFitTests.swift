import Foundation
import XCTest
import Bluetooth
#if canImport(BluetoothGAP)
import BluetoothGAP
#endif
import GATT
@testable import SunnyFit

final class SunnyFitTests: XCTestCase {
    
    func testStepperAdvertisement() throws {
        
        /*
         Sep 07 01:08:30.989  HCI Event        0x0000  A4:C1:38:E0:FC:1D  LE - Ext ADV - 1 Report - Normal - Public - A4:C1:38:E0:FC:1D  -68 dBm - NO. 012 SMART - Channel 37  RECV
             Parameter Length: 47 (0x2F)
             Num Reports: 0X01
             Report 0
                 Event Type: Connectable Advertising - Scannable Advertising - Legacy Advertising PDUs Used - Complete -
                 Address Type: Public
                 Peer Address: A4:C1:38:E0:FC:1D
                 Primary PHY: 1M
                 Secondary PHY: No Packets
                 Advertising SID: Unavailable
                 Tx Power: Unavailable
                 RSSI: -68 dBm
                 Periodic Advertising Interval: 0.000000ms (0x0)
                 Direct Address Type: Public
                 Direct Address: 00:00:00:00:00:00
                 Data Length: 21
                 Local Name: NO. 012 SMART
                 Data: 05 16 01 00 04 00 0E 09 4E 4F 2E 20 30 31 32 20 53 4D 41 52 54
         */
        
        let advertismentData: LowEnergyAdvertisingData = [0x05, 0x16, 0x01, 0x00, 0x04, 0x00, 0x0E, 0x09, 0x4E, 0x4F, 0x2E, 0x20, 0x30, 0x31, 0x32, 0x20, 0x53, 0x4D, 0x41, 0x52, 0x54]
        
        guard let name = advertismentData.localName else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(name, "NO. 012 SMART")
        
        /*
         Sep 07 01:08:30.991  HCI Event        0x0000  A4:C1:38:E0:FC:1D  LE - Ext ADV - 1 Report - Normal - Public - A4:C1:38:E0:FC:1D  -68 dBm - Manufacturer Specific Data - Channel 37  RECV
             Parameter Length: 49 (0x31)
             Num Reports: 0X01
             Report 0
                 Event Type: Connectable Advertising - Scannable Advertising - Scan Response - Legacy Advertising PDUs Used - Complete -
                 Address Type: Public
                 Peer Address: A4:C1:38:E0:FC:1D
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
                 Data: 02 01 06 13 FF 5A 00 00 A4 C1 38 E0 FC 1D 2A 10 00 00 00 00 00 00 D0
         */
        
        let scanResponse: LowEnergyAdvertisingData = [0x02, 0x01, 0x06, 0x13, 0xFF, 0x5A, 0x00, 0x00, 0xA4, 0xC1, 0x38, 0xE0, 0xFC, 0x1D, 0x2A, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xD0]
        
        guard let manufacturerData = scanResponse.manufacturerData else {
            XCTFail()
            return
        }
        
        /// https://www.emmicroelectronic.com/about
        /// Along with Renata and Micro Crysta,l EM makes up the Electronic Systems Segment of the Swatch Group.
        XCTAssertEqual(manufacturerData.companyIdentifier, .emMicroelectronicMarin)
        
        
        
        
    }
}
