//
//  FavoriteRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 28/03/2025.
//

import SwiftUI

class FavoritesRouter {
    
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

extension FavoritesRouter: Routable {
    
    func makeView() -> AnyView {
        let viewModel = FavoritesViewModel(router: self)
        let view = FavoritesView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: Hashable implementation

extension FavoritesRouter {
    
    func hash(into hasher: inout Hasher) {
        
    }
    
    static func == (lhs: FavoritesRouter, rhs: FavoritesRouter) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

extension FavoritesRouter {
    static let mock: FavoritesRouter = .init(rootCoordinator: AppRouter())
}
