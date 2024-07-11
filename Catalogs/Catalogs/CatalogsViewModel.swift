//
//  Created 7/10/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import Foundation

@Observable final class CatalogsViewModel {
    private static let booksStoreName = "BookCatalog"
    private let booksDataStore: DataStore
    private(set) var bookCatalog: BookCatalog
    
    init(booksDataStore: DataStore = DataStore(storeName: booksStoreName)) {
        self.booksDataStore = booksDataStore
        self.bookCatalog = BookCatalog(title: "Empty", books: [])
    }
}

// MARK: - Actions
extension CatalogsViewModel {
    
    func loadBooks() {
        guard bookCatalog.books.isEmpty else { return }
        
        Task {
            do {
                bookCatalog = try await booksDataStore.fetchBookCatalog()
            } catch {
                print("Unable to fetch BookCatalog from \(booksDataStore) due to \(error)")
            }
        }
    }
}
