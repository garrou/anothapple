//
//  SeasonInfos.swift
//  anothapp
//
//  Created by Adrien Garrouste on 03/04/2025.
//

import Foundation

struct SeasonInfos: Codable, Hashable {
    let id: Int
    let addedAt: Date
    let platform: Platform
    
    enum CodingKeys: String, CodingKey {
        case id, addedAt, platform
    }
    
    init(id: Int, addedAt: Date, platform: Platform) {
        self.id = id
        self.addedAt = addedAt
        self.platform = platform
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        platform = try container.decode(Platform.self, forKey: .platform)
        
        let dateString = try container.decode(String.self, forKey: .addedAt)
        addedAt = try Formatter.shared.stringToDate(str: dateString)
    }
}
