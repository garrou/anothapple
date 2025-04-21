//
//  SeriesPageRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import SwiftUI

class DiscoverRouter {
    
    private let rootCoordinator: NavigationCoordinator
    
    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
    
    func routeToDiscoverDetail(serie: ApiSerie) {
        let router = DiscoverDetailsRouter(rootCoordinator: rootCoordinator, serie: serie)
        rootCoordinator.push(router)
    }
}

// MARK: ViewFactory implementation

extension DiscoverRouter: Routable {
    
    func makeView() -> AnyView {
        let viewModel = DiscoverViewModel(router: self)
        let view = DiscoverView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: Hashable implementation

extension DiscoverRouter {
    
    func hash(into hasher: inout Hasher) {
    }
    
    static func == (lhs: DiscoverRouter, rhs: DiscoverRouter) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

extension DiscoverRouter {
    static let mock: DiscoverRouter = .init(rootCoordinator: AppRouter())
}
