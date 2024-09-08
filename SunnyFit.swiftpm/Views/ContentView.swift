import SwiftUI
import SunnyFit

struct ContentView: View {
    
    @EnvironmentObject
    var store: AccessoryManager
    
    var body: some View {
        NavigationView {
            NearbyDevicesView()
        }
    }
}
