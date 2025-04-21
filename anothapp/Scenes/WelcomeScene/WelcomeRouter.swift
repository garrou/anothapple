//
//  WelcomePageRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 20/03/2025.
//

import SwiftUI

class WelcomeRouter {
    
    private let rootCoordinator: NavigationCoordinator
    
    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
    
    func routeToLoginPage() {
        let router = LoginRouter(rootCoordinator: rootCoordinator)
        rootCoordinator.push(router)
    }
    
    func routeToHomePage() {
        let router = HomeRouter(rootCoordinator: rootCoordinator)
        rootCoordinator.push(router)
    }
}

// MARK: ViewFactory implementation

extension WelcomeRouter: Routable {
    
    func makeView() -> AnyView {
        let viewModel = WelcomeViewModel(router: self)
        let view = WelcomeView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: Hashable implementation

extension WelcomeRouter {
    
    func hash(into hasher: inout Hasher) {
    }
    
    static func == (lhs: WelcomeRouter, rhs: WelcomeRouter) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

extension WelcomeRouter {
    static let mock: WelcomeRouter = .init(rootCoordinator: AppRouter())
}
