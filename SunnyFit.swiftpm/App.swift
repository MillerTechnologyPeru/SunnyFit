import Foundation
import SwiftUI
import CoreBluetooth
import Bluetooth
import GATT
import SunnyFit

@main
struct SunnyFitApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AccessoryManager.shared)
        }
    }
}
