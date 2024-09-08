//
//  AccessoryInfo.swift
//
//
//  Created by Alsey Coleman Miller on 9/8/24.
//

import Foundation
import SunnyFit

/// SunnyFit Accessory Info
public struct SunnyFitAccessoryInfo: Equatable, Hashable, Codable, Sendable {
        
    public let symbol: String
    
    public let image: String
        
    public let manual: String?
        
    public let website: String?
}

public extension SunnyFitAccessoryInfo {
    
    struct Database: Equatable, Hashable, Sendable {
        
        public let accessories: [SunnyFitAccessoryType: SunnyFitAccessoryInfo]
    }
}

public extension SunnyFitAccessoryInfo.Database {
    
    subscript(type: SunnyFitAccessoryType) -> SunnyFitAccessoryInfo? {
        accessories[type]
    }
}

public extension SunnyFitAccessoryInfo.Database {
    
    internal static let encoder: PropertyListEncoder = {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        return encoder
    }()
    
    internal static let decoder: PropertyListDecoder = {
        let decoder = PropertyListDecoder()
        return decoder
    }()
    
    init(propertyList data: Data) throws {
        self = try Self.decoder.decode(SunnyFitAccessoryInfo.Database.self, from: data)
    }
    
    func encodePropertyList() throws -> Data {
        try Self.encoder.encode(self)
    }
}

extension SunnyFitAccessoryInfo.Database: Codable {
    
    public init(from decoder: Decoder) throws {
        let accessories = try [String: SunnyFitAccessoryInfo].init(from: decoder)
        self.accessories = try accessories.mapKeys {
            guard let key = SunnyFitAccessoryType(rawValue: $0) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid key \($0)"))
            }
            return key
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        try accessories
            .mapKeys { $0.rawValue }
            .encode(to: encoder)
    }
}
