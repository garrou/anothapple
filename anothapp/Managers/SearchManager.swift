//
//  SearchManager.swift
//  anothapp
//
//  Created by Adrien Garrouste on 03/04/2025.
//

import Foundation

class SearchManager {

    static let shared = SearchManager()
    private let searchService = SearchService()

    func getEpisodesBySerieBySeason(id: Int, season: Int) async -> [Episode] {
        (try? await searchService.fetchEpisodesBySerieIdBySeason(id: id, num: season)) ?? []
    }
}
