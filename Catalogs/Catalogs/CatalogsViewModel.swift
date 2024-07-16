//
//  Created 7/10/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import Foundation

@Observable final class CatalogsViewModel {
    private static let booksStoreName = "BookCatalog"
    private static let objectsStoreName = "ObjectCatalog"
    
    private let bookDataStore: DataStore
    private let objectDataStore: DataStore
    
    private(set) var bookCatalog: BookCatalog
    private(set) var objectCatalog: SpatialObjectCatalog
    
    var isShowingImmersiveSpace = false
    var selectedObject: SpatialObject?
    
    var hasBooks: Bool { !bookCatalog.books.isEmpty }
    var hasObjects: Bool { !objectCatalog.objects.isEmpty }

    init(booksDataStore: DataStore = DataStore(storeName: booksStoreName),
         objectDataStore: DataStore = DataStore(storeName: objectsStoreName)) {
        self.bookDataStore = booksDataStore
        self.objectDataStore = objectDataStore
        self.bookCatalog = BookCatalog(title: "Empty", books: [])
        self.objectCatalog = SpatialObjectCatalog(title: "Empty", objects: [])
    }
}

// MARK: - Spatial Object Actions
extension CatalogsViewModel {
    
    func loadObjects() {
        guard objectCatalog.objects.isEmpty else { return }
        
        Task {
            do {
                objectCatalog = try await objectDataStore.fetchObjectCatalog()
            } catch {
                print("Unable to fetch \(SpatialObjectCatalog.self) from \(objectDataStore) due to \(error)")
            }
        }
    }
    
    // TODO: implement move() method
}

// MARK: - Book Actions
extension CatalogsViewModel {
    
    func loadBooks() {
        guard bookCatalog.books.isEmpty else { return }
        
        Task {
            do {
                bookCatalog = try await bookDataStore.fetchBookCatalog()
            } catch {
                print("Unable to fetch \(BookCatalog.self) from \(bookDataStore) due to \(error)")
            }
        }
    }
    
    func moveBooks(atOffsets offsets: IndexSet, toOffset offset: Int) {
        bookCatalog.move(fromOffsets: offsets, toOffset: offset)
        save()
    }
    
    func removeBooks(fromOffsets offsets: IndexSet) {
        bookCatalog.remove(atOffsets: offsets)
        save()
    }
    
    func save() {
        do {
            try bookDataStore.save(bookCatalog: bookCatalog)
        } catch {
            print(error)
        }
    }
}
