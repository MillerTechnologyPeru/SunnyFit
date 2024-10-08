//
//  Integer.swift
//
//
//  Created by Alsey Coleman Miller on 9/7/24.
//

import Foundation

internal extension UInt16 {
    
    /// Initializes value from two bytes.
    init(bytes: (UInt8, UInt8)) {
        self = unsafeBitCast(bytes, to: UInt16.self)
    }
    
    /// Converts to two bytes. 
    var bytes: (UInt8, UInt8) {
        return unsafeBitCast(self, to: (UInt8, UInt8).self)
    }
}

internal extension Int16 {
    
    /// Initializes value from two bytes.
    init(bytes: (UInt8, UInt8)) {
        self = unsafeBitCast(bytes, to: Int16.self)
    }
    
    /// Converts to two bytes.
    var bytes: (UInt8, UInt8) {
        return unsafeBitCast(self, to: (UInt8, UInt8).self)
    }
}

internal extension UInt32 {
    
    /// Initializes value from four bytes.
    init(bytes: (UInt8, UInt8, UInt8, UInt8)) {
        self = unsafeBitCast(bytes, to: UInt32.self)
    }
    
    /// Converts to four bytes.
    var bytes: (UInt8, UInt8, UInt8, UInt8) {
        return unsafeBitCast(self, to: (UInt8, UInt8, UInt8, UInt8).self)
    }
}

internal extension Int32 {
    
    /// Initializes value from four bytes.
    init(bytes: (UInt8, UInt8, UInt8, UInt8)) {
        self = unsafeBitCast(bytes, to: Int32.self)
    }
    
    /// Converts to four bytes.
    var bytes: (UInt8, UInt8, UInt8, UInt8) {
        return unsafeBitCast(self, to: (UInt8, UInt8, UInt8, UInt8).self)
    }
}

internal extension UInt64 {
    
    /// Initializes value from four bytes.
    init(bytes: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)) {
        self = unsafeBitCast(bytes, to: UInt64.self)
    }
    
    /// Converts to eight bytes.
    var bytes: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) {
        return unsafeBitCast(self, to: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8).self)
    }
}
