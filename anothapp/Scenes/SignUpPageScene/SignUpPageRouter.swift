//
//  SignUpPageRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 21/03/2025.
//

import SwiftUI

class SignUpPageRouter: ObservableObject {
    
    private let rootCoordinator: NavigationCoordinator
    
    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
    
    func routeToLoginPage() {
        let router = LoginPageRouter(rootCoordinator: self.rootCoordinator)
        rootCoordinator.push(router)
    }
}

extension SignUpPageRouter: Routable {
    
    func makeView() -> AnyView {
        let viewModel = SignUpPageViewModel(router: self)
        let view = SignUpPageView(viewModel: viewModel)
        return AnyView(view)
    }
}

extension SignUpPageRouter {
    
    static func == (lhs: SignUpPageRouter, rhs: SignUpPageRouter) -> Bool {
        true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(1)
    }
}

extension SignUpPageRouter {
    static let mock: SignUpPageRouter = .init(rootCoordinator: AppRouter())
}
