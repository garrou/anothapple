//
//  ApiSerie.swift
//  anothapp
//
//  Created by Adrien Garrouste on 26/03/2025.
//

import Foundation

class ApiSerie: NSObject, Codable {
    let id: Int
    let title: String
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
    let creation: String
    let platforms: [Platform]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case poster
        case kinds
        case duration
        case country
        case synopsis = "description"
        case seasons
        case episodes
        case network
        case note
        case status
        case creation
        case platforms
    }
    
    init(id: Int, title: String, poster: String, kinds: [String], duration: Int, country: String, synopsis: String, seasons: Int, episodes: Int, network: String, note: Float, status: String, creation: String, platforms: [Platform]) {
        self.id = id
        self.title = title
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
    }
}
