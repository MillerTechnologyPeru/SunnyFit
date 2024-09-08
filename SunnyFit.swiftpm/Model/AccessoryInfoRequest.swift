//
//  AccessoryInfoRequest.swift
//
//
//  Created by Alsey Coleman Miller on 9/8/24.
//

import Foundation

public extension URLClient {
    
    func downloadSunnyFitAccessoryInfo() async throws -> SunnyFitAccessoryInfo.Database {
        let url = URL(string: "https://raw.githubusercontent.com/MillerTechnologyPeru/SunnyFit/master/SunnyFit.swiftpm/SunnyFit.plist")!
        let (data, urlResponse) = try await self.data(for: URLRequest(url: url))
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            throw URLError(.unknown)
        }
        guard httpResponse.statusCode == 200 else {
            throw URLError(.resourceUnavailable)
        }
        let decoder = PropertyListDecoder()
        return try decoder.decode(SunnyFitAccessoryInfo.Database.self, from: data)
    }
}
