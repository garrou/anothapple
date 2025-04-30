//
//  FavoriteRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 28/03/2025.
//

import SwiftUI

class SeriesStatusRouter {
    
    private let rootCoordinator: NavigationCoordinator
    let status: SerieStatus
    let title: String
    
    init(rootCoordinator: NavigationCoordinator, status: SerieStatus, title: String) {
        self.rootCoordinator = rootCoordinator
        self.status = status
        self.title = title
    }
    
    func routeToSerieDetails(serie: Serie) {
        let router = SerieDetailsRouter(rootCoordinator: rootCoordinator, serie: serie)
        rootCoordinator.push(router)
    }
    
    func routeToDiscoverDetails(serie: ApiSerie) {
        let router = DiscoverDetailsRouter(rootCoordinator: rootCoordinator, serie: serie)
        rootCoordinator.push(router)
    }
}

// MARK: ViewFactory implementation

extension SeriesStatusRouter: Routable {
    
    func makeView() -> AnyView {
        let viewModel = SeriesStatusViewModel(router: self)
        let view = SeriesStatusView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: Hashable implementation

extension SeriesStatusRouter {
    
    func hash(into hasher: inout Hasher) {
    }
    
    static func == (lhs: SeriesStatusRouter, rhs: SeriesStatusRouter) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

extension SeriesStatusRouter {
    static let mock: SeriesStatusRouter = .init(rootCoordinator: AppRouter(), status: .favorite, title: "Favoris")
}
