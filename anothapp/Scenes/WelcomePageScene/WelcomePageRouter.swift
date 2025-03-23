//
//  WelcomePageRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 20/03/2025.
//

import SwiftUI

class WelcomePageRouter {
    
    private let rootCoordinator: NavigationCoordinator
    
    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
    
    func routeToLoginPage() {
        let router = LoginPageRouter(rootCoordinator: self.rootCoordinator)
        rootCoordinator.push(router)
    }
}

extension WelcomePageRouter: Routable {
    
    func makeView() -> AnyView {
        let viewModel = WelcomePageViewModel(router: self)
        let view = WelcomePageView(viewModel: viewModel)
        return AnyView(view)
    }
}

extension WelcomePageRouter {
    
    static func == (lhs: WelcomePageRouter, rhs: WelcomePageRouter) -> Bool {
        true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(1)
    }
}

extension WelcomePageRouter {
    static let mock: WelcomePageRouter = .init(rootCoordinator: AppRouter())
}
