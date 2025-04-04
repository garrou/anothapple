//
//  HomePageViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import Foundation
import SwiftUI

enum AppTab {
    case series
    case discover
    case friends
    case statistics
}

class HomeViewModel: ObservableObject {
    
    private let router: HomeRouter
    
    @Published var selectedTab: AppTab = .series
    @Published var isMenuOpened: Bool = false
    @Published var View = EmptyView()
    @Published var continueWatchingView: AnyView?
    
    init(router: HomeRouter) {
        self.router = router
    }
    
    func getSeriesTabView() -> AnyView {
        router.getSeriesTabView()
    }
    
    func getDiscoverTabView() -> AnyView {
        router.getDiscoverTabView()
    }
    
    func getTimelineView() -> AnyView {
        router.getTimelineView()
    }
    
    func getFavoritesView() -> AnyView {
        let series = SeriesCacheManager.shared.getFavorites()
        return router.getSeriesStatusView(series: series)
    }
    
    func getWatchListView() -> AnyView {
        let series = SeriesListCacheManager.shared.getWatchList()
        return router.getSeriesStatusView(series: series)
    }
    
    @MainActor
    func loadSeriesToContinueView() async {
        let seriesToContinue = await SeriesManager.shared.getSeriesByStatus(status: "continue")
        continueWatchingView = router.getSeriesStatusView(series: seriesToContinue)
    }
    
    func getStoppedSeriesView() -> AnyView {
        let seriesStopped = SeriesCacheManager.shared.getSeriesByWatching(watching: false)
        return router.getSeriesStatusView(series: seriesStopped)
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
