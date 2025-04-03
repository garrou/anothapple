//
//  SeasonDetailsRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 03/04/2025.
//

import SwiftUI

class SeasonDetailsRouter {
    
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

extension SeasonDetailsRouter: Routable {
    
    func makeView() -> AnyView {
        let viewModel = SeasonDetailsViewModel(router: self)
        let view = SeasonDetailsView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: Hashable implementation

extension SeasonDetailsRouter {
    
    func hash(into hasher: inout Hasher) {
        
    }
    
    static func == (lhs: SeasonDetailsRouter, rhs: SeasonDetailsRouter) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

extension SeasonDetailsRouter {
    static let mock: SeasonDetailsRouter = .init(rootCoordinator: AppRouter(), id: 10051, season: 1)
}
