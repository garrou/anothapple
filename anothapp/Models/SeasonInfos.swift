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
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateString = try container.decode(String.self, forKey: .addedAt)
        
        if let date = formatter.date(from: dateString) {
            addedAt = date
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .addedAt,
                in: container,
                debugDescription: "Date string does not match expected format"
            )
        }
    }
}
