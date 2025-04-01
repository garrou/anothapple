//
//  SeriesPageRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import SwiftUI

class DiscoverDetailRouter {
    
    private let rootCoordinator: NavigationCoordinator
    private let serie: ApiSerie
    
    init(rootCoordinator: NavigationCoordinator, serie: ApiSerie) {
        self.rootCoordinator = rootCoordinator
        self.serie = serie
    }
    
    func routeToSerieDetail(serie: Serie) {
        let router = SerieDetailRouter(rootCoordinator: rootCoordinator, serie: serie)
        rootCoordinator.push(router)
    }
}

// MARK: ViewFactory implementation

extension DiscoverDetailRouter: Routable {
    
    func makeView() -> AnyView {
        let viewModel = DiscoverDetailViewModel(router: self, serie: serie)
        let view = DiscoverDetailView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: Hashable implementation

extension DiscoverDetailRouter {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(serie.id)
    }
    
    static func == (lhs: DiscoverDetailRouter, rhs: DiscoverDetailRouter) -> Bool {
        lhs.serie.id == rhs.serie.id
    }
}

extension DiscoverDetailRouter {
    static let mock: DiscoverDetailRouter = .init(rootCoordinator: AppRouter(), serie: Datasource.mockDiscoverSerie)
}
