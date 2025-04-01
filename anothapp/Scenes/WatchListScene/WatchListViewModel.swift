//
//  WatchListViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 01/04/2025.
//

import Foundation

class WatchListViewModel: ObservableObject {
    
    @Published var series: [Serie] = []
    @Published var isLoading = false
    
    private let router: WatchListRouter
    
    init(router: WatchListRouter) {
        self.router = router
    }
    
    func routeToDiscoverDetails(serie: Serie) async {
        let fetched = await ApiSeriesCacheManager.shared.getSerie(id: serie.id)
        if fetched != nil { router.routeToDiscoverDetails(serie: fetched!) }
    }
    
    @MainActor
    func loadWatchList() async {
        isLoading = true
        series = await SeriesListCacheManager.shared.getSeries()
        isLoading = false
    }
}

// MARK: - WatchListViewModel mock for preview

extension WatchListViewModel {
    static let mock: WatchListViewModel = .init(router: WatchListRouter.mock)
}
