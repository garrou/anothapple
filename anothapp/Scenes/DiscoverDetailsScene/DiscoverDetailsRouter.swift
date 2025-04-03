//
//  SeriesPageRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import SwiftUI

class DiscoverDetailsRouter {
    
    private let rootCoordinator: NavigationCoordinator
    private let serie: ApiSerie
    
    init(rootCoordinator: NavigationCoordinator, serie: ApiSerie) {
        self.rootCoordinator = rootCoordinator
        self.serie = serie
    }
    
    func routeToSerieDetail(serie: Serie) {
        let router = SerieDetailsRouter(rootCoordinator: rootCoordinator, serie: serie)
        rootCoordinator.push(router)
    }
}

// MARK: ViewFactory implementation

extension DiscoverDetailsRouter: Routable {
    
    func makeView() -> AnyView {
        let viewModel = DiscoverDetailsViewModel(router: self, serie: serie)
        let view = DiscoverDetailsView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: Hashable implementation

extension DiscoverDetailsRouter {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(serie.id)
    }
    
    static func == (lhs: DiscoverDetailsRouter, rhs: DiscoverDetailsRouter) -> Bool {
        lhs.serie.id == rhs.serie.id
    }
}

extension DiscoverDetailsRouter {
    static let mock: DiscoverDetailsRouter = .init(rootCoordinator: AppRouter(), serie: Datasource.mockDiscoverSerie)
}
