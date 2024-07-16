//
//  Created 7/12/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//

import SwiftUI

struct SpatialObjectBrowser: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    var viewModel: CatalogsViewModel
    
    var emptyMessage: some View {
        VStack(spacing: 20) {
            Text("No Spatial Objects")
                .font(.headline)
            Text("Tap the Add button to add an object.")
                .font(.subheadline)
        }
        .padding(20)
    }
    
    var objectList: some View {
        NavigationStack {
            List(viewModel.objectCatalog.objects) { object in
                SpatialObjectCell(object: object)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .onTapGesture {
                        show(object: object)
                    }
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: dismiss, 
                       label: { Text("Dismiss Immersive Space") })
                .disabled(!viewModel.isShowingImmersiveSpace)
            }
        }
    }
    
    var body: some View {
        if !viewModel.hasObjects {
            emptyMessage
        } else {
            objectList
        }
    }
}

// MARK: - Action
extension SpatialObjectBrowser {
    
    private func dismiss() {
        viewModel.isShowingImmersiveSpace = false
        Task { @MainActor in
            await dismissImmersiveSpace()
        }
    }
    
    private func show(object: SpatialObject) {
        viewModel.selectedObject = object
        
        if !viewModel.isShowingImmersiveSpace {
            viewModel.isShowingImmersiveSpace = true
            
            Task {
                await openImmersiveSpace(id: SpaceID.spatialObjects)
            }
        }
    }
}

struct SpatialObjectCell: View {
    
    let object: SpatialObject
    
    var body: some View {
        HStack {
            ListImage(imageUrl: object.imageUrl)
            Spacer()
            Text(object.title)
                .font(.headline)
        }
        .padding()
        .padding(.horizontal, 12)
        .background(.regularMaterial)
        .hoverEffect(.highlight)
    }
}
