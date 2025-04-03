//
//  ListViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 28/03/2025.
//

import Foundation

class FavoritesViewModel: ObservableObject {
    
    @Published var series: [Serie] = []
    @Published var isLoading = false
    
    private let router: FavoritesRouter
    
    init(router: FavoritesRouter) {
        self.router = router
    }
    
    func routeToSerieDetail(serie: Serie) {
        router.routeToSerieDetail(serie: serie)
    }
    
    func loadFavorites() {
        isLoading = true
        series = SeriesCacheManager.shared.getFavorites()
        isLoading = false
    }
}

// MARK: - DiscoverViewModel mock for preview

extension FavoritesViewModel {
    static let mock: FavoritesViewModel = .init(router: FavoritesRouter.mock)
}
