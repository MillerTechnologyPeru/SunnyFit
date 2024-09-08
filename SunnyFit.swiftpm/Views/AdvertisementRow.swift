//
//  SunnyFitAdvertisementRow.swift
//  
//
//  Created by Alsey Coleman Miller on 9/8/24.
//

import Foundation
import SwiftUI
import Bluetooth
import SunnyFit

struct SunnyFitAdvertisementRow: View {
    
    @EnvironmentObject
    private var store: AccessoryManager
    
    let accessory: SunnyFitAccessory
    
    var body: some View {
        StateView(
            accessory: accessory,
            information: store.accessoryInfo?[accessory.type]
        )
    }
}

internal extension SunnyFitAdvertisementRow {
    
    struct StateView: View {
        
        let accessory: SunnyFitAccessory
        
        let information: SunnyFitAccessoryInfo?
        
        var body: some View {
            HStack {
                // icon
                VStack {
                    if let information {
                        CachedAsyncImage(
                            url: URL(string: information.image),
                            content: { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }, placeholder: {
                                Image(systemName: information.symbol)
                            })
                    } else {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                }
                .frame(width: 40)
                
                // Text
                VStack(alignment: .leading) {
                    Text(verbatim: accessory.type.rawValue)
                        .font(.title3)
                    Text(verbatim: accessory.id.rawValue)
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
            }
            
        }
    }
}
/*
#if DEBUG
struct SunnyFitAdvertisementRow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                SunnyFitAdvertisementRow(
                    SunnyFitAccessory()
                )
            }
        }
    }
}
#endif
*/
