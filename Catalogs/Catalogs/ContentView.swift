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
                    .onAppear() {
                        viewModel.loadBooks()
                    }
                SpatialObjectBrowser()
                    .tabItem {
                        Label("Models", systemImage: "view.3d")
                    }
                    .tag(Tab.models)
                Settings()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag(Tab.settings)
            }
            .navigationTitle(
                selectedTab == .books ?
                viewModel.bookCatalog.title :
                selectedTab.rawValue
            )
        }
        .frame(minWidth: 600, maxWidth: 1000, minHeight: 800)
    }
}


// TODO: Migrate these to separate files...
struct SpatialObjectBrowser: View {
    
    var body: some View {
        Text("No Spatial Objects")
    }
}

struct Settings: View {
    
    var body: some View {
        Text("No Settings")
    }
}
