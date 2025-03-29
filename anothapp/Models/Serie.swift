//
//  Serie.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import Foundation

class Serie: NSObject, Codable {
    let id: Int
    let title: String
    let poster: String
    let kinds: [String]
    var favorite: Bool
    let duration: Int
    let addedAt: Date
    let country: String
    var watch: Bool
    let seasons: Int
    
    enum CodingKeys: String, CodingKey {
        case id, title, poster, kinds, favorite, duration, addedAt, country, watch, seasons
    }
    
    init(id: Int, title: String, poster: String, kinds: [String], favorite: Bool, duration: Int, addedAt: Date, country: String, watch: Bool, seasons: Int) {
        self.id = id
        self.title = title
        self.poster = poster
        self.kinds = kinds
        self.favorite = favorite
        self.duration = duration
        self.addedAt = addedAt
        self.country = country
        self.watch = watch
        self.seasons = seasons
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        poster = try container.decode(String.self, forKey: .poster)
        kinds = try container.decode([String].self, forKey: .kinds)
        favorite = try container.decode(Bool.self, forKey: .favorite)
        duration = try container.decode(Int.self, forKey: .duration)
        country = try container.decode(String.self, forKey: .country)
        watch = try container.decode(Bool.self, forKey: .watch)
        seasons = try container.decode(Int.self, forKey: .seasons)
        
        let dateString = try container.decode(String.self, forKey: .addedAt)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
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
