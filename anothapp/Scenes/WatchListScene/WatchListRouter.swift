//
//  WatchListRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 01/04/2025.
//

import SwiftUI

class WatchListRouter {
    
    private let rootCoordinator: NavigationCoordinator
    
    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
    
    func routeToDiscoverDetails(serie: ApiSerie) {
        let router = DiscoverDetailsRouter(rootCoordinator: rootCoordinator, serie: serie)
        rootCoordinator.push(router)
    }
}

// MARK: ViewFactory implementation

extension WatchListRouter: Routable {
    
    func makeView() -> AnyView {
        let viewModel = WatchListViewModel(router: self)
        let view = WatchListView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: Hashable implementation

extension WatchListRouter {
    
    func hash(into hasher: inout Hasher) {
        
    }
    
    static func == (lhs: WatchListRouter, rhs: WatchListRouter) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

extension WatchListRouter {
    static let mock: WatchListRouter = .init(rootCoordinator: AppRouter())
}
