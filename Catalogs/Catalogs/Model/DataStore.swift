//
//  Created 7/10/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import Foundation

final class DataStore {
    let storeName: String
    let bundle: Bundle
    
    let storeType = "json"
    
    let codableType = BookCatalog.self
    
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
        return try decoder.decode(codableType, from: data)
    }
}
