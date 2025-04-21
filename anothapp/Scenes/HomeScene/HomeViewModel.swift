//
//  HomePageViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import Foundation
import SwiftUI

enum AppTab {
    case series, discover, friends, statistics
}

class HomeViewModel: ObservableObject {
    
    private let router: HomeRouter
    
    @Published var selectedTab: AppTab = .series
    @Published var isMenuOpened = false
    @Published var isLoading = false
    
    init(router: HomeRouter) {
        self.router = router
    }
    
    func getSeriesTabView() -> AnyView {
        router.getSeriesTabView()
    }
    
    func getDiscoverTabView() -> AnyView {
        router.getDiscoverTabView()
    }
    
    func getStatisticsTabView() -> AnyView {
        router.getStatisticsTabView()
    }
    
    func routeToTimelineView() {
        router.routeToTimelineView()
    }
    
    func routeToProfielView() {
        router.routeToProfileView()
    }
    
    func routeToFavoritesView() {
        let series = SeriesCacheManager.shared.getFavorites()
        return router.routeToSeriesStatusView(series: series, title: "Favoris")
    }
    
    func routeToWatchListView() async {
        let series = await SeriesListCacheManager.shared.getWatchList()
        router.routeToSeriesStatusView(series: series, title: "Ma liste")
    }
    
    func routeToSeriesToContinueView() async {
        let seriesToContinue = await SeriesManager.shared.getSeriesByStatus(status: "continue")
        router.routeToSeriesStatusView(series: seriesToContinue, title: "En cours")
    }
    
    func routeToStoppedSeriesView() {
        let seriesStopped = SeriesCacheManager.shared.getSeriesByWatching(watching: false)
        return router.routeToSeriesStatusView(series: seriesStopped, title: "Arrêtées")
    }
    
    @MainActor
    func loadCaches() async {
        isLoading = true
        await StateManager.shared.loadCaches()
        isLoading = false
    }
    
    func logout() {
        SecurityManager.shared.clearUser()
        SeriesCacheManager.shared.clear()
        SeriesListCacheManager.shared.clear()
        router.routeToWelcomePage()
    }
}

// MARK: - HomeViewModel mock for preview

extension HomeViewModel {
    static let mock: HomeViewModel = .init(router: HomeRouter.mock)
}
