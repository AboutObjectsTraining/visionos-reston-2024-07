//
//  Created 7/12/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import Foundation

@Observable final class SpatialObject: Codable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case _title = "title"
    }
    
    let id: UUID
    var title: String
    
    var imageUrl: URL {
        let title = title.isEmpty ? "unknown" : title
        let urlPath = Bundle.main.path(forResource: title, ofType: "png") ?? ""
        return URL(fileURLWithPath: urlPath)
    }
    
    var modelUrl: URL {
        let title = title.isEmpty ? "unknown" : title
        let urlPath = Bundle.main.path(forResource: title, ofType: "usdz") ?? ""
        return URL(fileURLWithPath: urlPath)
    }
    
    init(id: UUID = UUID(), title: String) {
        self.id = id
        self.title = title
    }
}
