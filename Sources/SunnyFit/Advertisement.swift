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
        let address: BluetoothAddress
        switch type {
        case .stepperMini,
            .stepperTotalBody,
            .stepperTwist,
            .rowNRideUpright,
            .rowNRideFullBody,
            .rowNRideSquatAssist:
            guard manufacturerData.companyIdentifier == .emMicroelectronicMarin, manufacturerData.additionalData.count >= 7 else {
                return nil
            }
            address = BluetoothAddress(bigEndian: BluetoothAddress(data: Data(manufacturerData.additionalData[1 ..< 7]))!)
        case .ellipticalAirWalk:
            guard manufacturerData.additionalData.count == 4 else {
                return nil
            }
            let companyBytes = manufacturerData.companyIdentifier.rawValue.littleEndian.bytes
            address = BluetoothAddress(littleEndian: BluetoothAddress(bytes: (companyBytes.0, companyBytes.1, manufacturerData.additionalData[0], manufacturerData.additionalData[1], manufacturerData.additionalData[2], manufacturerData.additionalData[3])))
        }
        
        self.init(id: address, type: type)
    }
}
