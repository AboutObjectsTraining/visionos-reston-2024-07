//
//  Created 7/10/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import Foundation

enum StoreError: Error {
    case unableToEncode(message: String)
    case unableToDecode(message: String)
    case unableToSave(message: String)
}

final class DataStore {
    let storeName: String
    let bundle: Bundle
    
    let storeType = "json"
    
    let decoder = JSONDecoder()
    let encoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    
    var storeFileUrl: URL {
        URL.documentsDirectory
            .appendingPathComponent(storeName)
            .appendingPathExtension(storeType)
    }
    
    var templateFileUrl: URL {
        bundle.url(forResource: storeName, withExtension: storeType)!
    }
    
    init(storeName: String, bundle: Bundle = Bundle.main) {
        self.storeName = storeName
        self.bundle = bundle
        copyStoreFileIfNecessary()
    }
    
    private func copyStoreFileIfNecessary() {
        if !FileManager.default.fileExists(atPath: storeFileUrl.path) {
            try? FileManager.default.copyItem(at: templateFileUrl, to: storeFileUrl)
        }
    }
    
    func fetchBookCatalog() async throws -> BookCatalog {
        let (data, _) = try await URLSession.shared.data(from: storeFileUrl)
        return try decoder.decode(BookCatalog.self, from: data)
    }
    
    func fetchObjectCatalog() async throws -> SpatialObjectCatalog {
        let (data, _) = try await URLSession.shared.data(from: storeFileUrl)
        return try decoder.decode(SpatialObjectCatalog.self, from: data)
    }
    
    func save(bookCatalog: BookCatalog) throws {
        guard let data = try? encoder.encode(bookCatalog) else {
            throw StoreError.unableToEncode(message: "Unable to encode \(bookCatalog)")
        }
        
        do {
            try data.write(to: storeFileUrl)
        } catch {
            throw StoreError.unableToSave(message: "Unable to write to \(storeFileUrl); error was \(error)")
        }
    }
}
