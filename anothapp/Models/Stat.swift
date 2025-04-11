//
//  Stat.swift
//  anothapp
//
//  Created by Adrien Garrouste on 11/04/2025.
//

struct Stat: Codable {
    
    let label: String
    
    let value: Int
}

struct UserStat: Codable {
    
    let monthTime: Int

    let totalTime: Int

    let nbSeries: Int

    let nbSeasons: Int

    let nbEpisodes: Int

    let bestMonth: Stat?
}
