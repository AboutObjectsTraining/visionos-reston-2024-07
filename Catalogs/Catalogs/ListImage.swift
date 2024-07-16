//
//  Created 7/12/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI

struct ListImage: View {
    let imageUrl: URL
    
    var body: some View {
        AsyncImage(url: imageUrl) { phase in
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

