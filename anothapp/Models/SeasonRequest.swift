//
//  SeasonRequest.swift
//  anothapp
//
//  Created by Adrien Garrouste on 01/04/2025.
//

import Foundation

struct SeasonRequest: Codable {
    let id: Int
    let num: Int
}

struct UpdateSeasonRequest: Codable {
    let id: Int
    let platform: Int
    let viewedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, platform, viewedAt
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(platform, forKey: .platform)
        let dateString = Helper.shared.dateToString(date: viewedAt, format: "yyyy-MM-dd HH:mm:ss")
        try container.encode(dateString, forKey: .viewedAt)
    }
}
