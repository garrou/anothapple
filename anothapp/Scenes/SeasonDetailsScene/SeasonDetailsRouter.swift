//
//  SeasonDetailsRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 03/04/2025.
//

import SwiftUI

class SeasonDetailsRouter {
    
    private let rootCoordinator: NavigationCoordinator
    let serie: Serie
    let season: Season
    
    init(rootCoordinator: NavigationCoordinator, serie: Serie, season: Season) {
        self.rootCoordinator = rootCoordinator
        self.serie = serie
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
        hasher.combine(self.hashValue)
    }
    
    static func == (lhs: SeasonDetailsRouter, rhs: SeasonDetailsRouter) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

extension SeasonDetailsRouter {
    static let mock: SeasonDetailsRouter = .init(rootCoordinator: AppRouter(), serie: Datasource.mockSerie, season: Datasource.mockSeason)
}
