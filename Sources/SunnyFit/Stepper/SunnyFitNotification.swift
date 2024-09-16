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
public enum SunnyFitNotification: Equatable, Hashable {
    
    public static var uuid: BluetoothUUID { .sunnyFitNotificationCharacteristic3 }
    
    case status(SunnyFitNotification.Status)
    case counter(SunnyFitNotification.Counter)
    
    public init?(data: Data) {
        switch data.count {
        case Status.length:
            guard let value = Status(data: data) else {
                assertionFailure()
                return nil
            }
            self = .status(value)
        case Counter.length:
            guard let value = Counter(data: data) else {
                assertionFailure()
                return nil
            }
            self = .counter(value)
        default:
            return nil
        }
    }
}

public extension SunnyFitNotification {
    
    struct Status: Equatable, Hashable {
        
        internal static var length: Int { 20 }
        
        public let calories: UInt16
        
        public let repsPerMin: UInt16
        
        public let time: UInt16
        
        public init?(data: Data) {
            guard data.count == Self.length else {
                return nil
            }
            self.repsPerMin = UInt16(littleEndian: UInt16(bytes: (data[6], data[7])))
            self.calories = UInt16(littleEndian: UInt16(bytes: (data[10], data[11])))
            self.time = UInt16(littleEndian: UInt16(bytes: (data[16], data[17])))
        }
    }
}

public extension SunnyFitNotification {
    
    struct Counter: Equatable, Hashable {
        
        internal static var length: Int { 12 }
        
        public let reps: UInt16
        
        public init?(data: Data) {
            guard data.count == Self.length else {
                return nil
            }
            self.reps = UInt16(littleEndian: UInt16(bytes: (data[0], data[1])))
        }
    }
}

// MARK: - Central

public extension CentralManager {
    
    /// Recieve stream of SunnyFit device values.
    func sunnyFitStatus(
        characteristic: Characteristic<Peripheral, AttributeID>
    ) async throws -> AsyncIndefiniteStream<SunnyFitNotification> {
        assert(characteristic.uuid == .sunnyFitNotificationCharacteristic3)
        let notifications = try await self.notify(for: characteristic)
        // parse notifications
        return AsyncIndefiniteStream<SunnyFitNotification> { build in
            for try await data in notifications {
                guard let notification = SunnyFitNotification(data: data) else {
                    throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Invalid data."))
                }
                build(notification)
            }
        }
    }
}
