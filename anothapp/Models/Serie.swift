//
//  Serie.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//
import Foundation

struct Serie: Codable, Hashable {
    let id: Int
    let title: String
    let poster: String
    let kinds: [String]
    let favorite: Bool
    let duration: Int
    let addedAt: String
    let country: String
    let watch: Bool
    let seasons: Int
}
