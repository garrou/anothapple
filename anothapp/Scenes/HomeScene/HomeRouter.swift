//
//  HomePageViewRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import SwiftUI

class HomeRouter {
    
    private let rootCoordinator: NavigationCoordinator
    
    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
    
    func getSeriesTabView() -> AnyView {
        SeriesRouter(rootCoordinator: rootCoordinator).makeView()
    }
    
    func getDiscoverTabView() -> AnyView {
        DiscoverRouter(rootCoordinator: rootCoordinator).makeView()
    }
    
    func getStatisticsTabView() -> AnyView {
        DashboardRouter(rootCoordinator: rootCoordinator).makeView()
    }
    
    func routeToSeriesStatusView(series: [Serie], title: String) {
        let router = SeriesStatusRouter(rootCoordinator: rootCoordinator, series: series, title: title)
        rootCoordinator.push(router)
    }
    
    func routeToTimelineView() {
        let router = TimelineRouter(rootCoordinator: rootCoordinator)
        rootCoordinator.push(router)
    }
    
    func routeToWelcomePage() {
        rootCoordinator.popToRoot()
    }
}

// MARK: ViewFactory implementation

extension HomeRouter: Routable {
    
    func makeView() -> AnyView {
        let viewModel = HomeViewModel(router: self)
        let view = HomeView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: Hashable implementation

extension HomeRouter {
    
    func hash(into hasher: inout Hasher) {
        
    }
    
    static func == (lhs: HomeRouter, rhs: HomeRouter) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

extension HomeRouter {
    static let mock: HomeRouter = .init(rootCoordinator: AppRouter())
}
