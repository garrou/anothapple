//
//  Season.swift
//  anothapp
//
//  Created by Adrien Garrouste on 29/03/2025.
//

struct Season: Codable, Hashable {
    let number: Int
    let episodes: Int
    let image: String?
    let interval: String
}
