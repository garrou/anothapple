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
        let isLoggedIn = await AuthManager.shared.login(identifier: identifier, password: password)
        if (isLoggedIn) {
            router.routeToHomePage()
        }
    }
}

// MARK: - LoginViewModel mock for preview

extension LoginViewModel {
    static let mock: LoginViewModel = .init(router: LoginRouter.mock)
}
