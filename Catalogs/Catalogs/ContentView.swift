//
//  Created 7/10/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI

// TODO: Migrate to view model?
enum Tab: String {
    case books = "Books"
    case models = "Models"
    case settings = "Settings"
}

struct ContentView: View {
    // TODO: Migrate to view model.
    @State var selectedTab = Tab.books
    
    var viewModel: CatalogsViewModel
    
    var body: some View {
        
        NavigationStack {
            TabView(selection: $selectedTab) {
                BooksBrowser(viewModel: viewModel)
                    .tabItem {
                        Label("Books", systemImage: "books.vertical.fill")
                    }
                    .tag(Tab.books)
                    .onAppear {
                        viewModel.loadBooks()
                    }
                SpatialObjectBrowser(viewModel: viewModel)
                    .tabItem {
                        Label("Models", systemImage: "view.3d")
                    }
                    .tag(Tab.models)
                    .onAppear {
                        viewModel.loadObjects()
                    }
                SettingsBrowser()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag(Tab.settings)
            }
            .navigationTitle(
                selectedTab == .books ?
                viewModel.bookCatalog.title :
                    selectedTab == .models ?
                viewModel.objectCatalog.title :
                    selectedTab.rawValue
            )
        }
        .frame(minWidth: 600, maxWidth: 1000, minHeight: 800)
    }
}


// TODO: Migrate these to separate files...

