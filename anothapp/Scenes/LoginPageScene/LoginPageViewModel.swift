//
//  LoginPageViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 20/03/2025.
//

import Foundation

class LoginPageViewModel: ObservableObject {
    
    @Published var identifier = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var hasError = false
    
    private let router: LoginPageRouter
    private let authService = AuthService()
    
    init(router: LoginPageRouter) {
        self.router = router
    }
    
    func navigateToSignUpPage() {
        router.routeToSignUpPage()
    }
    
    func performLogin() async {
        let loginModel = LoginModel(identifier: identifier, password: password)
        let authenticated = await authService.login(loginModel: loginModel)
        
        if authenticated {
            
        } else {
            errorMessage = "Identifiant ou mot de passe incorrect"
            hasError = true
        }
    }
}

// MARK: - LoginPageViewModel mock for preview

extension LoginPageViewModel {
    static let mock: LoginPageViewModel = .init(router: LoginPageRouter.mock)
}
