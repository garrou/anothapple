//
//  LoginPageRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 20/03/2025.
//

import SwiftUI

class LoginPageRouter: ObservableObject {
    
    private let rootCoordinator: NavigationCoordinator
    
    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
    
    func routeToSignUpPage() {
        let router = SignUpPageRouter(rootCoordinator: self.rootCoordinator)
        rootCoordinator.push(router)
    }
}

extension LoginPageRouter: Routable {
    
    func makeView() -> AnyView {
        let viewModel = LoginPageViewModel(router: self)
        let view = LoginPageView(viewModel: viewModel)
        return AnyView(view)
    }
}

extension LoginPageRouter {
    
    static func == (lhs: LoginPageRouter, rhs: LoginPageRouter) -> Bool {
        true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(1)
    }
}

extension LoginPageRouter {
    static let mock: LoginPageRouter = .init(rootCoordinator: AppRouter())
}
