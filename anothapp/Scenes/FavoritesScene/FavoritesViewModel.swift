//
//  ListViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 28/03/2025.
//

import Foundation

class FavoritesViewModel: ObservableObject {
    
    @Published var series: [Serie] = []
    
    private let router: FavoritesRouter
    private let seriesService = SerieService()
    
    init(router: FavoritesRouter) {
        self.router = router
    }
    
    func routeToSerieDetail(serie: Serie) {
        router.routeToSerieDetail(serie: serie)
    }
    
    @MainActor
    func loadFavorites() {
        series = SeriesCacheManager.shared.getFavorites()
    }
}

// MARK: - DiscoverViewModel mock for preview

extension FavoritesViewModel {
    static let mock: FavoritesViewModel = .init(router: FavoritesRouter.mock)
}
