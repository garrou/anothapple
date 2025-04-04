//
//  TimelineRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 04/04/2025.
//

import SwiftUI

class TimelineRouter {
    
    private let rootCoordinator: NavigationCoordinator
    
    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
    
    func routeToSerieDetails(serie: Serie) {
        let router = SerieDetailsRouter(rootCoordinator: rootCoordinator, serie: serie)
        rootCoordinator.push(router)
    }
}

// MARK: ViewFactory implementation

extension TimelineRouter: Routable {
    
    func makeView() -> AnyView {
        let viewModel = TimelineViewModel(router: self)
        let view = TimelineView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: Hashable implementation

extension TimelineRouter {
    
    func hash(into hasher: inout Hasher) {
    
    }
    
    static func == (lhs: TimelineRouter, rhs: TimelineRouter) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

extension TimelineRouter {
    static let mock: TimelineRouter = .init(rootCoordinator: AppRouter())
}
