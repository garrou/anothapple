//
//  EpisodesViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 03/04/2025.
//

import Foundation

class EpisodesViewModel: ObservableObject {
    
    @Published var episodes: [Episode] = []
    @Published var isLoading = false
    
    private let router: EpisodesRouter
    let id: Int
    let season: Int
    
    
    init(router: EpisodesRouter, id: Int, season: Int) {
        self.router = router
        self.id = id
        self.season = season
    }
    
    @MainActor
    func loadEpisodes() async {
        isLoading = true
        episodes = await SearchManager.shared.getEpisodesBySerieBySeason(id: id, season: season)
        isLoading = false
    }
}

// MARK: - WatchListViewModel mock for preview

extension EpisodesViewModel {
    static let mock: EpisodesViewModel = .init(router: EpisodesRouter.mock, id: 10051, season: 1)
}
