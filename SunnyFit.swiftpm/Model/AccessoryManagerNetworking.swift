//
//  AccessoryManagerNetworking.swift
//
//
//  Created by Alsey Coleman Miller on 9/8/24.
//

import Foundation

internal extension AccessoryManager {
    
    func loadURLSession() -> URLSession {
        URLSession(configuration: .ephemeral)
    }
}

public extension AccessoryManager {
    
    @discardableResult
    func downloadAccessoryInfo() async throws -> SunnyFitAccessoryInfo.Database {
        // fetch from server
        let value = try await urlSession.downloadSunnyFitAccessoryInfo()
        // write to disk
        try saveAccessoryInfoFile(value)
        return value
    }
}
