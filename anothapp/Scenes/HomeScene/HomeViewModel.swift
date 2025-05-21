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
    
    func routeToProfileView() {
        router.routeToProfileView()
    }
    
    func routeToFavoritesView() {
        router.routeToSeriesStatusView(status: .favorite, title: "Favoris")
    }
    
    func routeToWatchListView() {
        router.routeToSeriesStatusView(status: .watchlist, title: "Ma liste")
    }
    
    func routeToSeriesToContinueView() {
        router.routeToSeriesStatusView(status: .continueWatching, title: "En cours")
    }
    
    func routeToStoppedSeriesView() {
        router.routeToSeriesStatusView(status: .stopped, title: "Arrêtées")
    }
    
    func routeToSettingsView() {
        router.routeToSettingsView()
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
