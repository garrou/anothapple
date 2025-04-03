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
}

class HomeViewModel: ObservableObject {
    
    private let router: HomeRouter
    
    @Published var selectedTab: AppTab = .series
    @Published var isMenuOpened: Bool = false
    
    init(router: HomeRouter) {
        self.router = router
    }
    
    func getSeriesTabView() -> AnyView {
        router.getSeriesTabView()
    }
    
    func getDiscoverTabView() -> AnyView {
        router.getDiscoverTabView()
    }
    
    func getFavoritesView() -> AnyView {
        router.getFavoritesView()
    }
    
    func getWatchListView() -> AnyView {
        router.getWatchListView()
    }
    
    func logout() {
        SecurityManager.shared.clearUser()
        SeriesCacheManager.shared.clear()
        SeriesListCacheManager.shared.clear()
        router.routeToWelcomePage()
    }
}

// MARK: - HomePageViewModel mock for preview

extension HomeViewModel {
    static let mock: HomeViewModel = .init(router: HomeRouter.mock)
}
