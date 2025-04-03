//
//  LoginPageViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 20/03/2025.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var identifier = ""
    @Published var password = ""
    
    private let router: LoginRouter
    
    var isInvalidForm: Bool {
        identifier.isEmpty || password.isEmpty
    }
    
    init(router: LoginRouter) {
        self.router = router
    }
    
    func navigateToSignUpPage() {
        router.routeToSignUpPage()
    }
    
    func performLogin() async {
        if let user = await AuthManager.shared.login(identifier: identifier, password: password) {
            SecurityManager.shared.storeUser(user)
            router.routeToHomePage()
        }
    }
}

// MARK: - LoginPageViewModel mock for preview

extension LoginViewModel {
    static let mock: LoginViewModel = .init(router: LoginRouter.mock)
}
