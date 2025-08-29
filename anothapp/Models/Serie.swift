//
//  Serie.swift
//  anothapp
//
//  Created by Adrien Garrouste on 01/04/2025.
//

import Foundation

class Serie: BaseSerie {
    let poster: String
    let kinds: [String]
    let duration: Int
    let country: String
    let seasons: Int
    var favorite: Bool
    var addedAt: Date
    var watch: Bool
    var note: Int?
    
    enum CodingKeys: String, CodingKey {
        case poster, kinds, duration, country, seasons, favorite, addedAt, watch, note
    }
    
    init(id: Int, title: String, poster: String, kinds: [String], duration: Int, country: String, seasons: Int, favorite: Bool, addedAt: Date, watch: Bool, note: Int) {
        self.poster = poster
        self.kinds = kinds
        self.duration = duration
        self.country = country
        self.seasons = seasons
        self.favorite = favorite
        self.addedAt = addedAt
        self.watch = watch
        self.note = note
        super.init(id: id, title: title)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        poster = try container.decode(String.self, forKey: .poster)
        kinds = try container.decode([String].self, forKey: .kinds)
        favorite = (try? container.decode(Bool.self, forKey: .favorite)) ?? false
        duration = try container.decode(Int.self, forKey: .duration)
        country = try container.decode(String.self, forKey: .country)
        watch = (try? container.decode(Bool.self, forKey: .watch)) ?? false
        seasons = try container.decode(Int.self, forKey: .seasons)
        note = try? container.decode(Int.self, forKey: .note)
        
        if let dateString = (try? container.decode(String.self, forKey: .addedAt)) {
            addedAt = try Helper.shared.stringToDate(str: dateString)
        } else {
            addedAt = Date()
        }
        try super.init(from: decoder)
    }
}
