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
    
    init(router: EpisodesRouter) {
        self.router = router
    }
    
    var season: Int {
        router.season
    }
    
    @MainActor
    func loadEpisodes() async {
        isLoading = true
        episodes = await SearchManager.shared.getEpisodesBySerieBySeason(id: router.id, season: router.season)
        isLoading = false
    }
}

// MARK: - EpisodesViewModel mock for preview

extension EpisodesViewModel {
    static let mock: EpisodesViewModel = .init(router: EpisodesRouter.mock)
}
