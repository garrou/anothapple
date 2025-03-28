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
    let addedAt: String
    let country: String
    var watch: Bool
    let seasons: Int
    
    init(id: Int, title: String, poster: String, kinds: [String], favorite: Bool, duration: Int, addedAt: String, country: String, watch: Bool, seasons: Int) {
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
}
