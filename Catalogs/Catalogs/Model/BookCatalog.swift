//
//  Created 7/10/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import Foundation
import Observation

@Observable final class BookCatalog: Codable, Identifiable, CustomStringConvertible {
    
    enum CodingKeys: String, CodingKey {
        case id
        case _title = "title"
        case _books = "books"
    }
    
    let id: UUID
    var title: String
    var books: [Book]
    
    var description: String {
        "title: \(title), books: \(books)\n"
    }
    
    init(id: UUID = UUID(), title: String, books: [Book]) {
        self.id = id
        self.title = title
        self.books = books
    }
}

extension BookCatalog {
    
    func remove(atOffsets indexSet: IndexSet) {
        books.remove(atOffsets: indexSet)
    }
    
    func move(fromOffsets offsets: IndexSet, toOffset offset: Int) {
        books.move(fromOffsets: offsets, toOffset: offset)
    }
}
