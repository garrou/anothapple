//
//  LoginPageRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 20/03/2025.
//

import SwiftUI

class LoginRouter: ObservableObject {
    
    private let rootCoordinator: NavigationCoordinator
    
    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
    
    func routeToSignUpPage() {
        let router = SignUpRouter(rootCoordinator: rootCoordinator)
        rootCoordinator.push(router)
    }
    
    func routeToHomePage() {
        rootCoordinator.popToRoot()
    }
}

// MARK: ViewFactory implementation

extension LoginRouter: Routable {
    
    func makeView() -> AnyView {
        let viewModel = LoginViewModel(router: self)
        let view = LoginView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: Hashable implementation

extension LoginRouter {
    
    func hash(into hasher: inout Hasher) {
        
    }
    
    static func == (lhs: LoginRouter, rhs: LoginRouter) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

extension LoginRouter {
    static let mock: LoginRouter = .init(rootCoordinator: AppRouter())
}
