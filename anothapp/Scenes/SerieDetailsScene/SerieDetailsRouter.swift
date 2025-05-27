//
//  SerieDetailRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 25/03/2025.
//

import SwiftUI

class SerieDetailsRouter: ObservableObject {
    
    private let rootCoordinator: NavigationCoordinator
    private let serie: Serie
    
    init(rootCoordinator: NavigationCoordinator, serie: Serie) {
        self.rootCoordinator = rootCoordinator
        self.serie = serie
    }
    
    func routeToDiscoverDetails(serie: ApiSerie) {
        let router = DiscoverDetailsRouter(rootCoordinator: rootCoordinator, serie: serie)
        rootCoordinator.push(router)
    }
    
    func routeToHomePage() {
        rootCoordinator.popLast()
    }
    
    func routeToEpisodesView(id: Int, season: Int) {
        let router = EpisodesRouter(rootCoordinator: rootCoordinator, id: id, season: season)
        rootCoordinator.push(router)
    }
    
    func routeToSeasonDetailsView(serie: Serie, season: Season) {
        let router = SeasonDetailsRouter(rootCoordinator: rootCoordinator, serie: serie, season: season)
        rootCoordinator.push(router)
    }
    
    func getDashboardView(userId: String) -> AnyView {
        DashboardRouter(rootCoordinator: rootCoordinator, userId: userId).makeView()
    }
}

// MARK: ViewFactory implementation

extension SerieDetailsRouter: Routable {
    
    func makeView() -> AnyView {
        let viewModel = SerieDetailsViewModel(router: self, serie: serie)
        let view = SerieDetailsView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: Hashable implementation

extension SerieDetailsRouter {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(serie.id)
    }
    
    static func == (lhs: SerieDetailsRouter, rhs: SerieDetailsRouter) -> Bool {
        lhs.serie.id == rhs.serie.id
    }
}

extension SerieDetailsRouter {
    static let mock: SerieDetailsRouter = .init(rootCoordinator: AppRouter(), serie: Datasource.mockSerie)
}
