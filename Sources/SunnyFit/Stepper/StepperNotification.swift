//
//  StepperNotification.swift
//
//
//  Created by Alsey Coleman Miller on 9/8/24.
//

import Foundation
import Bluetooth
import GATT

/// SunnyFit Stepper Notification
public struct StepperNotification: Equatable, Hashable {
    
    public static var uuid: BluetoothUUID { .sunnyFitStepperNotificationCharacteristic3 }
    
    internal static var length: Int { 27 }
    
    public let calories: UInt16
    
    public let reps: UInt16
    
    public let time: UInt16
    
    public init?(data: Data) {
        guard data.count == Self.length else {
            return nil
        }
        self.calories = UInt16(littleEndian: UInt16(bytes: (data[17], data[18])))
        self.reps = UInt16(littleEndian: UInt16(bytes: (data[13], data[14])))
        self.time = UInt16(littleEndian: UInt16(bytes: (data[23], data[24])))
    }
}
