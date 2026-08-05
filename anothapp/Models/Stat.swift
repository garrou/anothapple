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
    
    let seasonsMonthCurrentYear: [Stat];

    let episodesMonthCurrentYear: [Stat];
        
    let timeYears: [Stat];
        
    let seasonsYears: [Stat];
        
    let episodesYears: [Stat];
        
    let seasonsMonths: [Stat];
                
    let bestMonths: [Stat];
                
    let seriesRankingTime: [Stat];
                
    let seriesKinds: [Stat];
                
    let seasonsPlatforms: [Stat];
                
    let seriesCountries: [Stat];
                
    let seriesNotes: [Stat];
    
    enum CodingKeys: String, CodingKey {
        case monthTime, totalTime, nbSeries, nbSeasons, nbEpisodes, bestMonth, seasonsMonthCurrentYear, episodesMonthCurrentYear, timeYears, seasonsYears, episodesYears, seasonsMonths, bestMonths, seriesRankingTime, seriesKinds, seasonsPlatforms, seriesCountries, seriesNotes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        monthTime = (try container.decode(Int.self, forKey: .monthTime))
        totalTime = (try container.decode(Int.self, forKey: .totalTime))
        nbSeries = (try container.decode(Int.self, forKey: .nbSeries))
        nbSeasons = (try container.decode(Int.self, forKey: .nbSeasons))
        nbEpisodes = (try container.decode(Int.self, forKey: .nbEpisodes))
        bestMonth = (try? container.decode(Stat.self, forKey: .bestMonth))
        seasonsMonthCurrentYear = (try? container.decode([Stat].self, forKey: .seasonsMonthCurrentYear)) ?? []
        episodesMonthCurrentYear = (try? container.decode([Stat].self, forKey: .episodesMonthCurrentYear)) ?? []
        timeYears = (try? container.decode([Stat].self, forKey: .timeYears)) ?? []
        seasonsYears = (try? container.decode([Stat].self, forKey: .seasonsYears)) ?? []
        episodesYears = (try? container.decode([Stat].self, forKey: .episodesYears)) ?? []
        seasonsMonths = (try? container.decode([Stat].self, forKey: .seasonsMonths)) ?? []
        bestMonths = (try? container.decode([Stat].self, forKey: .bestMonths)) ?? []
        seriesRankingTime = (try? container.decode([Stat].self, forKey: .seriesRankingTime)) ?? []
        seriesKinds = (try? container.decode([Stat].self, forKey: .seriesKinds)) ?? []
        seasonsPlatforms = (try? container.decode([Stat].self, forKey: .seasonsPlatforms)) ?? []
        seriesCountries = (try? container.decode([Stat].self, forKey: .seriesCountries)) ?? []
        seriesNotes = (try? container.decode([Stat].self, forKey: .seriesNotes)) ?? []
    }
}
