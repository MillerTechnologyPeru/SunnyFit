//
//  AccessoryManagerFile.swift
//
//
//  Created by Alsey Coleman Miller on 9/8/24.
//

import Foundation
import SunnyFit

public extension AccessoryManager {
    
    /// Accessory information database.
    var accessoryInfo: SunnyFitAccessoryInfo.Database? {
        get {
            // return cache
            if let cache = fileManagerCache.accessoryInfo {
                return cache
            } else {
                // attempt to read cache in background.
                if fileManagerCache.accessoryInfoReadTask == nil {
                    fileManagerCache.accessoryInfoReadTask = Task(priority: .userInitiated) {
                        do { try readAccessoryInfoFile() }
                        catch CocoaError.fileReadNoSuchFile {
                            log("Accessory information file not found, will attempt download.")
                            // download if no file.
                            do { try await downloadAccessoryInfo() }
                            catch URLError.notConnectedToInternet {
                                // cannot download
                            }
                            catch {
                                log("Unable to download accessory info. \(error)")
                            }
                        }
                        catch {
                            log("Unable to read accessory info. \(error)")
                        }
                    }
                }
                return nil
            }
        }
    }
}

internal extension AccessoryManager {
    
    func loadDocumentDirectory() -> URL {
        guard let url = fileManager.documentDirectory else {
            fatalError()
        }
        return url
    }
    
    func loadCachesDirectory() -> URL {
        guard let url = fileManager.cachesDirectory else {
            fatalError()
        }
        return url
    }
    
    var accessoryInfoFileURL: URL {
        documentDirectory.appendingPathComponent(FileName.accessoryInfo.rawValue)
    }
    
    func saveAccessoryInfoFile(_ value: SunnyFitAccessoryInfo.Database) throws {
        let data = try value.encodePropertyList()
        try data.write(to: accessoryInfoFileURL, options: [.atomic])
        // cache value
        if fileManagerCache.accessoryInfo != value {
            fileManagerCache.accessoryInfo = value
        }
        log("Wrote file \(accessoryInfoFileURL.path)")
    }
    
    @discardableResult
    func readAccessoryInfoFile() throws -> SunnyFitAccessoryInfo.Database {
        let data = try Data(contentsOf: accessoryInfoFileURL, options: [.mappedIfSafe])
        log("Read file \(accessoryInfoFileURL.path)")
        let decoder = PropertyListDecoder()
        let value = try decoder.decode(SunnyFitAccessoryInfo.Database.self, from: data)
        // cache value
        if fileManagerCache.accessoryInfo != value {
            fileManagerCache.accessoryInfo = value
        }
        return value
    }
}

internal extension AccessoryManager {
    
    struct FileManagerCache {
        
        var accessoryInfo: SunnyFitAccessoryInfo.Database?
        
        var accessoryInfoReadTask: Task<Void, Never>?
    }
    
    enum FileName: String {
        
        case accessoryInfo = "SunnyFit.plist"
        
    }
}
