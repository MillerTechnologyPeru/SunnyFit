//
//  Advertisement.swift
//
//
//  Created by Alsey Coleman Miller on 9/8/24.
//

import Foundation
import Bluetooth
import GATT

public extension SunnyFitAccessory {
    
    init?(name: String, manufacturerData: GATT.ManufacturerSpecificData) {
        guard let type = SunnyFitAccessoryType(rawValue: name) else {
            return nil
        }
        guard manufacturerData.companyIdentifier == .emMicroelectronicMarin, manufacturerData.additionalData.count >= 7 else {
            return nil
        }
        let address = BluetoothAddress(bigEndian: BluetoothAddress(data: Data(manufacturerData.additionalData[1 ..< 7]))!)
        self.init(id: address, type: type)
    }
}
