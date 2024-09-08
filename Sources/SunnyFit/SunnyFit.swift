import Foundation
import Bluetooth
import GATT

/// SunnyFit Bluetooth Accessory
public struct SunnyFitAccessory: Equatable, Hashable, Codable, Sendable, Identifiable {
    
    public let id: BluetoothAddress
    
    public let type: SunnyFitAccessoryType
}

/// SunnyFit Accessory Name
public enum SunnyFitAccessoryType: String, Codable, CaseIterable, Sendable {
    
    /// Smart Mini Stepper
    ///
    ///
    /// ![Image](https://sunnyhealthfitness.com/cdn/shop/files/sunny-health-fitness-steppers-smart-mini-stepper-w-exercise-bands-no012smart-1_1100x.jpg?v=1715123786)
    ///
    /// [Product Page](https://sunnyhealthfitness.com/products/smart-mini-stepper-with-exercise-bands-no-012smart)
    case miniStepper                = "NO. 012 SMART"
    
    /// Total Body Smart Exercise Stepper Machine
    ///
    ///
    /// ![Image](https://sunnyhealthfitness.com/cdn/shop/files/Sunny-health-fitness-Accessories-Multi-Purpose-Air-drive-Adjustable-Standing-Desk-SF-A023001-00_07ec88e8-1548-4c6f-af62-803979a620d5_1100x.jpg?v=1696268183)
    ///
    /// [Product Page](https://sunnyhealthfitness.com/products/total-body-smart-exercise-stepper-machine-sf-s0978smart)
    case totalBodyStepper           = "SF-S0978SMART"
    
    /// Smart Twist Stepper Machine
    ///
    /// ![Image](https://sunnyhealthfitness.com/cdn/shop/files/sunny-health-fitness-steppers-smart-twist-stepper-machine-sf-s0979smart-1_1100x.jpg?v=1720034544)
    ///
    /// [Product Page](https://sunnyhealthfitness.com/products/smart-twist-stepper-machine-sf-s0979smart)
    case twistStepper               = "SF-S0979SMART"
}
