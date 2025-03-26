//
//  ApiSerie.swift
//  anothapp
//
//  Created by Adrien Garrouste on 26/03/2025.
//

import Foundation

struct ApiSerie: Codable, Hashable {
    let id: Int
    let title: String
    let poster: String
    let kinds: [String]
    let duration: Int
    let country: String
    let description: String
    let seasons: Int
    let episodes: Int
    let network: String
    let note: Float
    let status: String
    let creation: String
    let platforms: [Platform]
}

struct Platform: Codable, Hashable {
    let name: String
    let logo: String
}
