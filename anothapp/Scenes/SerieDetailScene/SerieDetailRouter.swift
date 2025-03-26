//
//  SerieDetailRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 25/03/2025.
//

import SwiftUI

class SerieDetailRouter: ObservableObject {
    
    private let rootCoordinator: NavigationCoordinator
    private let serie: Serie
    
    init(rootCoordinator: NavigationCoordinator, serie: Serie) {
        self.rootCoordinator = rootCoordinator
        self.serie = serie
    }
}

// MARK: ViewFactory implementation

extension SerieDetailRouter: Routable {
    
    func makeView() -> AnyView {
        let viewModel = SerieDetailViewModel(router: self, serie: serie)
        let view = SerieDetailView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: Hashable implementation

extension SerieDetailRouter {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(serie.id)
    }
    
    static func == (lhs: SerieDetailRouter, rhs: SerieDetailRouter) -> Bool {
        lhs.serie.id == rhs.serie.id
    }
}

extension SerieDetailRouter {
    static let mock: SerieDetailRouter = .init(rootCoordinator: AppRouter(), serie: Datasource.mockSerie)
}
