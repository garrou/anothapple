//
//  Serie.swift
//  anothapp
//
//  Created by Adrien Garrouste on 01/04/2025.
//

import Foundation

class Serie: NSObject, Codable {
    let id: Int
    let title: String
    let poster: String
    let kinds: [String]
    let duration: Int
    let country: String
    let seasons: Int
    var favorite: Bool
    var addedAt: Date
    var watch: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, title, poster, kinds, duration, country, seasons, favorite, addedAt, watch
    }
    
    init(id: Int, title: String, poster: String, kinds: [String], duration: Int, country: String, seasons: Int, favorite: Bool, addedAt: Date, watch: Bool) {
        self.id = id
        self.title = title
        self.poster = poster
        self.kinds = kinds
        self.duration = duration
        self.country = country
        self.seasons = seasons
        self.favorite = favorite
        self.addedAt = addedAt
        self.watch = watch
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        poster = try container.decode(String.self, forKey: .poster)
        kinds = try container.decode([String].self, forKey: .kinds)
        favorite = (try? container.decode(Bool.self, forKey: .favorite)) ?? false
        duration = try container.decode(Int.self, forKey: .duration)
        country = try container.decode(String.self, forKey: .country)
        watch = (try? container.decode(Bool.self, forKey: .watch)) ?? false
        seasons = try container.decode(Int.self, forKey: .seasons)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateString = (try? container.decode(String.self, forKey: .addedAt)) ?? formatter.string(from: Date())
        
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
