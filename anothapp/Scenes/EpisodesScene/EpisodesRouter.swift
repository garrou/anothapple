//
//  EpisodesRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 03/04/2025.
//

import SwiftUI

class EpisodesRouter {
    
    private let rootCoordinator: NavigationCoordinator
    
    let id: Int
    let season: Int
    
    init(rootCoordinator: NavigationCoordinator, id: Int, season: Int) {
        self.rootCoordinator = rootCoordinator
        self.id = id
        self.season = season
    }
}

// MARK: ViewFactory implementation

extension EpisodesRouter: Routable {
    
    func makeView() -> AnyView {
        let viewModel = EpisodesViewModel(router: self, id: id, season: season)
        let view = EpisodesView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: Hashable implementation

extension EpisodesRouter {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: EpisodesRouter, rhs: EpisodesRouter) -> Bool {
        lhs.id == rhs.id && lhs.season == rhs.season
    }
}

extension EpisodesRouter {
    static let mock: EpisodesRouter = .init(rootCoordinator: AppRouter(), id: 10051, season: 1)
}
