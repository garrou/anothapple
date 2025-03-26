//
//  SignUpPageRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 21/03/2025.
//

import SwiftUI

class SignUpRouter: ObservableObject {
    
    private let rootCoordinator: NavigationCoordinator
    
    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
    
    func routeToLoginPage() {
        let router = LoginRouter(rootCoordinator: rootCoordinator)
        rootCoordinator.push(router)
    }
}

// MARK: ViewFactory implementation

extension SignUpRouter: Routable {
    
    func makeView() -> AnyView {
        let viewModel = SignUpViewModel(router: self)
        let view = SignUpView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: Hashable implementation

extension SignUpRouter {
    
    func hash(into hasher: inout Hasher) {
        
    }
    
    static func == (lhs: SignUpRouter, rhs: SignUpRouter) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

extension SignUpRouter {
    static let mock: SignUpRouter = .init(rootCoordinator: AppRouter())
}
