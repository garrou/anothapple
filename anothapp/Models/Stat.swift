//
//  Stat.swift
//  anothapp
//
//  Created by Adrien Garrouste on 11/04/2025.
//

import Foundation

struct Stat: Codable, Hashable, Identifiable {
    
    let id = UUID()
    
    let label: String
    
    let value: Int
    
    enum CodingKeys: String, CodingKey {
        case label, value
    }
}

struct UserStat: Codable {
    
    let monthTime: Int
    
    let totalTime: Int
    
    let nbSeries: Int
    
    let nbSeasons: Int
    
    let nbEpisodes: Int
    
    let bestMonth: Stat?
}
