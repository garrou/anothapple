//
//  Timeline.swift
//  anothapp
//
//  Created by Adrien Garrouste on 04/04/2025.
//

import Foundation

struct Timeline: Codable, Hashable {
    
    let showId: Int
    let showTitle: String
    let addedAt: Date
    let season: Season
    
    enum CodingKeys: String, CodingKey {
        case showId, showTitle, addedAt, season
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.showId = try container.decode(Int.self, forKey: .showId)
        self.showTitle = try container.decode(String.self, forKey: .showTitle)
        self.season = try container.decode(Season.self, forKey: .season)
        
        let dateString = try container.decode(String.self, forKey: .addedAt)
        addedAt = try Helper.shared.stringToDate(str: dateString)
    }
}
