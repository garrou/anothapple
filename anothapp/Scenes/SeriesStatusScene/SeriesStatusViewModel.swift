//
//  ListViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 28/03/2025.
//

import Foundation

class SeriesStatusViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var series: [Serie] = []
    @Published var title: String
    
    private let router: SeriesStatusRouter
    private let status: SerieStatus
    
    init(router: SeriesStatusRouter) {
        self.router = router
        self.status = router.status
        self.title = router.title
    }
    
    func routeToSerieDetails(serie: Serie) async {
        if SeriesCacheManager.shared.isAlreadyAdded(id: serie.id) {
            router.routeToSerieDetails(serie: serie)
        } else {
            if let fetched = await ApiSeriesCacheManager.shared.getSerie(id: serie.id) {
                router.routeToDiscoverDetails(serie: fetched)
            }
        }
    }
    
    @MainActor
    func loadSeries() async {
        isLoading = true
        switch(status) {
        case .favorite:
            series = SeriesCacheManager.shared.getFavorites()
            break
        case .watchlist:
            series = await SeriesListCacheManager.shared.getWatchList()
            break
        case .continueWatching:
            series = await SeriesManager.shared.getSeriesByStatus(status: .continueWatching)
            break
        case .stopped:
            series = SeriesCacheManager.shared.getSeriesByWatching(watching: false)
            break
        case .shared:
            break;
        }
        isLoading = false
    }
}

// MARK: - SeriesStatusViewModel mock for preview

extension SeriesStatusViewModel {
    static let mock: SeriesStatusViewModel = .init(router: SeriesStatusRouter.mock)
}
