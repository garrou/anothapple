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
    @Published var errorMessage = ""
    @Published var hasError = false
    
    private let router: LoginRouter
    private let authService = AuthService()
    private let securityHelper = SecurityHelper()
    
    init(router: LoginRouter) {
        self.router = router
    }
    
    func navigateToSignUpPage() {
        router.routeToSignUpPage()
    }
    
    func performLogin() async {
        let loginRequest = LoginRequest(identifier: identifier, password: password)
        
        do {
            let user = try await authService.login(loginRequest: loginRequest)
            
            if user != nil {
                SecurityHelper.storeUser(user!)
                router.routeToHomePage()
            } else {
                errorMessage = "Identifiant ou mot de passe incorrect"
                hasError = true
            }
        } catch {
            errorMessage = "Une erreur est survenue"
            hasError = true
        }
    }
}

// MARK: - LoginPageViewModel mock for preview

extension LoginViewModel {
    static let mock: LoginViewModel = .init(router: LoginRouter.mock)
}
