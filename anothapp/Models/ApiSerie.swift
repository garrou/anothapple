//
//  ApiSerie.swift
//  anothapp
//
//  Created by Adrien Garrouste on 26/03/2025.
//

import Foundation

class ApiSerie: BaseSerie {
    let poster: String
    let kinds: [String]
    let duration: Int
    let country: String
    let synopsis: String
    let seasons: Int
    let episodes: Int
    let network: String
    let note: Float
    let status: String
    let creation: Int
    let platforms: [Platform]
    
    enum CodingKeys: String, CodingKey {
        case poster, kinds, duration, country, synopsis = "description", seasons, episodes, network, note, status, creation, platforms
    }
    
    init(id: Int, title: String, poster: String, kinds: [String], duration: Int, country: String, synopsis: String, seasons: Int, episodes: Int, network: String, note: Float, status: String, creation: Int, platforms: [Platform]) {
        self.poster = poster
        self.kinds = kinds
        self.duration = duration
        self.country = country
        self.synopsis = synopsis
        self.seasons = seasons
        self.episodes = episodes
        self.network = network
        self.note = note
        self.status = status
        self.creation = creation
        self.platforms = platforms
        super.init(id: id, title: title)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.poster = try container.decode(String.self, forKey: .poster)
        self.kinds = try container.decode([String].self, forKey: .kinds)
        self.duration = try container.decode(Int.self, forKey: .duration)
        self.country = try container.decode(String.self, forKey: .country)
        self.synopsis = try container.decode(String.self, forKey: .synopsis)
        self.seasons = try container.decode(Int.self, forKey: .seasons)
        self.episodes = try container.decode(Int.self, forKey: .episodes)
        self.network = try container.decode(String.self, forKey: .network)
        self.note = try container.decode(Float.self, forKey: .note)
        self.status = try container.decode(String.self, forKey: .status)
        self.creation = try container.decode(Int.self, forKey: .creation)
        self.platforms = try container.decode([Platform].self, forKey: .platforms)
        try super.init(from: decoder)
    }
}
