//
//  Created 7/10/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI

struct BooksBrowser: View {
    var viewModel: CatalogsViewModel
    
    var emptyMessage: some View {
        VStack(spacing: 20) {
            Text("No Books")
                .font(.headline)
            Text("Tap the Add button to add a book.")
                .font(.subheadline)
        }
        .padding(20)
    }
    
    var bookList: some View {
        List {
            ForEach(viewModel.bookCatalog.books) { book in
                Text(book.title)
            }
        }
        .onAppear() {
            viewModel.loadBooks()
        }
    }
    
    var body: some View {
        bookList
        
//        if viewModel.bookCatalog.books.isEmpty {
//            emptyMessage
//        } else {
//            bookList
//        }
    }
}
