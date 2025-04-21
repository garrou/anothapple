//
//  SeriesPageRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import SwiftUI

class SeriesRouter {
    
    private let rootCoordinator: NavigationCoordinator
    
    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
    
    func routeToSerieDetail(serie: Serie) {
        let router = SerieDetailsRouter(rootCoordinator: rootCoordinator, serie: serie)
        rootCoordinator.push(router)
    }
}

// MARK: ViewFactory implementation

extension SeriesRouter: Routable {
    
    func makeView() -> AnyView {
        let viewModel = SeriesViewModel(router: self)
        let view = SeriesView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: Hashable implementation

extension SeriesRouter {
    
    func hash(into hasher: inout Hasher) {
    }
    
    static func == (lhs: SeriesRouter, rhs: SeriesRouter) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

extension SeriesRouter {
    static let mock: SeriesRouter = .init(rootCoordinator: AppRouter())
}
