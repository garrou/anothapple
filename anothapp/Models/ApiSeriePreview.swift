//
//  ApiSeriePreview.swift
//  anothapp
//
//  Created by Adrien Garrouste on 20/04/2025.
//

import Foundation

class ApiSeriePreview: BaseSerie {
    
    let poster: String
    
    enum CodingKeys: String, CodingKey {
        case poster
    }
    
    init(id: Int, title: String, poster: String) {
        self.poster = poster
        super.init(id: id, title: title)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.poster = try container.decode(String.self, forKey: .poster)
        try super.init(from: decoder)
    }
}
