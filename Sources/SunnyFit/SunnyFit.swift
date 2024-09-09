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
    case stepperMini                    = "NO. 012 SMART"
    
    /// Total Body Smart Exercise Stepper Machine
    ///
    ///
    /// ![Image](https://sunnyhealthfitness.com/cdn/shop/files/Sunny-health-fitness-Accessories-Multi-Purpose-Air-drive-Adjustable-Standing-Desk-SF-A023001-00_07ec88e8-1548-4c6f-af62-803979a620d5_1100x.jpg?v=1696268183)
    ///
    /// [Product Page](https://sunnyhealthfitness.com/products/total-body-smart-exercise-stepper-machine-sf-s0978smart)
    case stepperTotalBody               = "SF-S0978SMART"
    
    /// Smart Twist Stepper Machine
    ///
    /// ![Image](https://sunnyhealthfitness.com/cdn/shop/files/sunny-health-fitness-steppers-smart-twist-stepper-machine-sf-s0979smart-1_1100x.jpg?v=1720034544)
    ///
    /// [Product Page](https://sunnyhealthfitness.com/products/smart-twist-stepper-machine-sf-s0979smart)
    case stepperTwist                   = "SF-S0979SMART"
    
    /// Air Walk Trainer Glider Exercise Machine
    ///
    /// ![Image](https://sunnyhealthfitness.com/cdn/shop/products/SUFFB1_1_1100x.jpg?v=1662075591)
    ///
    /// [Product Page](https://sunnyhealthfitness.com/products/sunny-health-and-fitness-sf-e902-air-walk-trainer-glider-w-lcd-monitor)
    case ellipticalAirWalk              = "SF-E902 SMART-H"
    
    /// Smart Upright Row-N-Ride® Exerciser
    ///
    /// ![Image](https://sunnyhealthfitness.com/cdn/shop/files/Sunny-health-fitness-rowers-smart-upright-row-n-ride-exerciser-No.-077SMART-00_1100x.jpg?v=1699899291)
    ///
    /// [Product Page](https://sunnyhealthfitness.com/products/smart-upright-row-n-ride-exerciser-no-077smart)
    case rowNRideUpright                = "NO. 077SMART"
    
    /// Full Body Adjustable Multi-function Smart Row-N-Ride® Trainer
    ///
    /// ![Image](https://sunnyhealthfitness.com/cdn/shop/files/sunny-health-fitness-row-n-ride-full-body-adjustable-multifunction-smart-row-n-ride-trainer-sf-a022070-2_1100x.jpg?v=1715640072)
    ///
    /// [Product Page](https://sunnyhealthfitness.com/products/full-body-adjustable-multi-function-smart-row-n-ride-trainer-sf-a022070)
    case rowNRideFullBody               = "SF-A022070"
    
    /// Row-N-Ride® Hydraulic Squat Assist Trainer
    ///
    /// ![Image](https://sunnyhealthfitness.com/cdn/shop/files/sunny-health-fitness-strength-row-n-ride-pro-smart-squat-assist-trainer-sf-a023053-2_1100x.jpg?v=1719863219)
    ///
    /// [Product Page](https://sunnyhealthfitness.com/collections/row-n-ride/products/row-n-ride-pro-smart-squat-assist-trainer-sf-a023053)
    case rowNRideSquatAssist            = "SF-A023053"
}
