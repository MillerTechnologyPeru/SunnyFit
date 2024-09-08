//
//  FileManager.swift
//  
//
//  Created by Alsey Coleman Miller on 9/8/24.
//

import Foundation

internal extension FileManager {
    
    var cachesDirectory: URL? {
        return urls(for: .cachesDirectory, in: .userDomainMask).first
    }
    
    var documentDirectory: URL? {
        return urls(for: .documentDirectory, in: .userDomainMask).first
    }
}
