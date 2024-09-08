//
//  BluetoothUUID.swift
//  
//
//  Created by Alsey Coleman Miller on 9/7/24.
//

import Foundation
import Bluetooth

public extension BluetoothUUID {
    
    static var sunnyFitStepperService: BluetoothUUID {
        BluetoothUUID(rawValue: "FD710001-E950-458E-8A4D-A1CBC5AA4CCE")!
    }
    
    static var sunnyFitStepperCommandCharacteristic: BluetoothUUID {
        BluetoothUUID(rawValue: "FD710002-E950-458E-8A4D-A1CBC5AA4CCE")!
    }
    
    static var sunnyFitStepperNotificationCharacteristic: BluetoothUUID {
        BluetoothUUID(rawValue: "OxFD710003-E950-458E-8A4D-A1CBC5AA4CCE")!
    }
    
    static var sunnyFitStepperNotificationCharacteristic2: BluetoothUUID {
        BluetoothUUID(rawValue: "OxFD710004-E950-458E-8A4D-A1CBC5AA4CCE")!
    }
    
    static var sunnyFitStepperCommandCharacteristic2: BluetoothUUID {
        BluetoothUUID(rawValue: "OxFD710005-E950-458E-8A4D-A1CBC5AA4CCE")!
    }
    
    static var sunnyFitStepperNotificationCharacteristic3: BluetoothUUID {
        BluetoothUUID(rawValue: "OxFD710005-E950-458E-8A4D-A1CBC5AA4CCE")!
    }
}
