//
//  Error.swift
//
//
//  Created by Alsey Coleman Miller on 9/8/24.
//

import Foundation
import Bluetooth
import SunnyFit

/// SunnyFit app errors.
public enum SunnyFitAppError: Error {
    
    /// Bluetooth is not available on this device.
    case bluetoothUnavailable
    
    /// No service with UUID found.
    case serviceNotFound(BluetoothUUID)
    
    /// No characteristic with UUID found.
    case characteristicNotFound(BluetoothUUID)
    
    /// The characteristic's value could not be parsed. Invalid data.
    case invalidCharacteristicValue(BluetoothUUID)
    
    /// Not a compatible peripheral
    case incompatiblePeripheral
}
