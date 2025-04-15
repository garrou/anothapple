//
//  BaseSerie.swift
//  anothapp
//
//  Created by Adrien Garrouste on 14/04/2025.
//

import Foundation

class BaseSerie: NSObject, Codable {
    
    let id: Int
    
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id, title
    }
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
    }
}
