//
//  StepperView.swift
//
//
//  Created by Alsey Coleman Miller on 9/8/24.
//

import Foundation
import SwiftUI
import Bluetooth
import GATT
import SunnyFit

struct StepperView: View {
    
    let accessory: SunnyFitAccessory
    
    @EnvironmentObject
    private var store: AccessoryManager
    
    @State
    private var values = [(Date, StepperNotification)]()
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                ForEach(values, id: \.0) { (date, status) in
                    HStack {
                        Text(date, style: .time)
                        VStack {
                            Text("\(status.time)s")
                            Text("\(status.reps) reps")
                            Text("\(status.calories)kcal")
                        }
                    }
                }
            }
        }
        .navigationTitle("Energy")
        .task {
            do {
                let stream = try await store.startStepper(for: accessory.id)
                Task {
                    do {
                        for try await value in stream {
                            values.append((Date(), value))
                        }
                    }
                    catch {
                        store.log("Unable to start exercise. \(error)")
                    }
                }
            }
            catch {
                store.log("Unable to start exercise. \(error)")
            }
        }
    }
}
