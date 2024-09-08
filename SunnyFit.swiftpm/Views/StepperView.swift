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
    private var status = Status()
    
    private static var timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(timeElapsed)")
            Text("\(status.reps) reps")
            Text("\(status.repsPerMinute) reps/min")
            Text("\(status.calories) kcal")
        }
        .navigationTitle("Stepper")
        .task {
            do {
                let stream = try await store.startStepper(for: accessory.id)
                Task {
                    do {
                        for try await value in stream {
                            self.status.timeElapsed = numericCast(value.time)
                            self.status.repsPerMinute = numericCast(value.repsPerMin)
                            self.status.calories = Float(value.calories) / 10
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

private extension StepperView {
    
    var timeElapsed: String {
        Self.timeFormatter.string(from: DateComponents(second: Int(status.timeElapsed)))!
    }
}

internal extension StepperView {
    
    struct Status: Equatable, Hashable {
        
        var timeElapsed: UInt = 0
        
        var calories: Float = 0
        
        var repsPerMinute: UInt = 0
                
        var reps: UInt = 0
    }
}
