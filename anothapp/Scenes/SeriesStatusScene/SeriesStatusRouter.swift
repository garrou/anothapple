//
//  FavoriteRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 28/03/2025.
//

import SwiftUI

class SeriesStatusRouter {
    
    private let rootCoordinator: NavigationCoordinator
    let series: [Serie]
    let title: String
    
    init(rootCoordinator: NavigationCoordinator, series: [Serie], title: String) {
        self.rootCoordinator = rootCoordinator
        self.series = series
        self.title = title
    }
    
    func routeToSerieDetail(serie: Serie) {
        let router = SerieDetailsRouter(rootCoordinator: rootCoordinator, serie: serie)
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
    static let mock: SeriesStatusRouter = .init(rootCoordinator: AppRouter(), series: [Datasource.mockSerie], title: "Mock")
}
