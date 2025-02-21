//
//  Created 7/10/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import XCTest
@testable import Catalogs

class DataStoreTests: XCTestCase {
    
    func testFetchBookCatalog() async throws {
        let store = DataStore(storeName: "BookCatalog")
        let bookCatalog = try await store.fetchBookCatalog()
        print(bookCatalog)
    }
    
    func testEncodeCatalog() async throws {
        let store = DataStore(storeName: "BookCatalog")
        let bookCatalog = try await store.fetchBookCatalog()
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(bookCatalog)
        let text = String(data: data, encoding: .utf8)
        print(text!)
    }
}
