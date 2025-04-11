//
//  StatisticsRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 11/04/2025.
//

import SwiftUI

class DashboardRouter: ObservableObject {
    
    private let rootCoordinator: NavigationCoordinator
    
    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
}

// MARK: ViewFactory implementation

extension DashboardRouter: Routable {
    
    func makeView() -> AnyView {
        let viewModel = DashboardViewModel(router: self)
        let view = DashboardView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: Hashable implementation

extension DashboardRouter {
    
    func hash(into hasher: inout Hasher) {
        
    }
    
    static func == (lhs: DashboardRouter, rhs: DashboardRouter) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

extension DashboardRouter {
    static let mock: DashboardRouter = .init(rootCoordinator: AppRouter())
}
