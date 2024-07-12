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
                NavigationLink {
                    BookDetail(book: book)
                        .environment(viewModel)
                } label: {
                    BookCell(book: book)
                }
            }
            .onMove { offsets, offset in
                viewModel.moveBooks(atOffsets: offsets, toOffset: offset)
            }
            .onDelete { offsets in
                viewModel.removeBooks(fromOffsets: offsets)
            }
        }
    }
    
    var body: some View {
        Group {
            if !viewModel.hasBooks {
                emptyMessage
            } else {
                bookList
            }
        }
        .toolbar {
            EditButton()
        }
    }
}

struct BookCell: View {
    let book: Book
    
    var body: some View {
        HStack(spacing: 18) {
            CoverImage(coverImageUrl: book.coverImageUrl)
            VStack(alignment: .leading, spacing: 8) {
                Text(book.title)
                HStack(spacing: 12) {
                    Text(book.year)
                    Text(book.author)
                }
            }
            Spacer()
            ProgressView(value: book.percentComplete)
                .progressViewStyle(CompletionProgressViewStyle())
        }
    }
}

struct CoverImage: View {
    let coverImageUrl: URL
    
    var body: some View {
        AsyncImage(url: coverImageUrl) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            } else if phase.error == nil {
                ProgressView()
            } else {
                ZStack {
                    Rectangle()
                        .fill(.regularMaterial)
                        .frame(width: 80, height: 120)
                    Image(systemName: "photo")
                        .imageScale(.large)
                }
                .padding(.horizontal, 12)
            }
        }
        .cornerRadius(3.0)
    }
}

#Preview {
    Group {
        let book = Book(title: "1983", year: "1999", author: "George Orwell")
        BookCell(book: book)
            .padding(30)
            .glassBackgroundEffect()
        
        let book2 = Book(title: "1984", year: "1999", author: "George Orwell")
        BookCell(book: book2)
            .padding(30)
            .glassBackgroundEffect()
    }
}
