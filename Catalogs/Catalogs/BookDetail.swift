//
//  Created 7/11/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI

struct BookDetail: View {
    @Bindable var book: Book
    @Environment(\.dismiss) private var dismiss
    @Environment(\.editMode) private var editMode
    @Environment(CatalogsViewModel.self) private var viewModel
    @FocusState private var isFocused: Bool
    
    var isEditing: Bool {
        editMode?.wrappedValue.isEditing ?? false
    }
    
    var percentReadView: some View {
        VStack(alignment: .leading) {
            Text("Percent Read:")
                .font(.subheadline)
            Text(book.percentComplete, format: .percent)
            
            if isEditing {
                Slider(value: $book.percentComplete, in: 0...1, step: 0.1)
            }
        }
    }
    
    var body: some View {
        Form {
            Section {
                TitledCell(title: "Title", value: $book.title)
                    .focused($isFocused)
                TitledCell(title: "Year", value: $book.year)
            }
            
            Section {
                TitledCell(title: "Author", value: $book.author)
            }
            
            percentReadView
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
            }
        }
        .onChange(of: isEditing) {
            isFocused = isEditing
            if !isEditing {
                viewModel.save()
                dismiss()
            }
        }
    }
}

struct TitledCell: View {
    var title: String
    @Binding var value: String
    
    @Environment(\.editMode) private var editMode
    
    var isEditing: Bool {
        editMode?.wrappedValue.isEditing ?? false
    }
    
    var titleField: some View {
        Text(title)
            .font(.subheadline)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            titleField
            
            if isEditing {
                TextField(title, text: $value)
                    .padding(.top, -12)
            } else {
                Text(value)
            }
        }
        .font(.headline)
    }
}
