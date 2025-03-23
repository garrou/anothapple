//
//  SignUpPageViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 21/03/2025.
//

import Foundation

class SignUpPageViewModel: ObservableObject {
    
    @Published var email: String
    @Published var username: String
    @Published var password: String
    @Published var confirmPassword: String
    @Published var errorMessage: String
    @Published var hasError: Bool = false

    private let router: SignUpPageRouter
    
    init(router: SignUpPageRouter) {
        self.router = router
        email = ""
        username = ""
        password = ""
        confirmPassword = ""
        errorMessage = ""
    }
    
    func navigateToLoginPage() {
        router.routeToLoginPage()
    }
    
    func performSignUp() {
        if email.isEmpty || username.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            errorMessage = "Tous les champs sont requis"
            hasError = true
            return
        }
        if !isValidEmail() {
            errorMessage = "Email invalide"
            hasError = true
            return
        }
        if username.count < 3 {
            errorMessage = "Le nom d'utilisateur doit contenir au moins 3 caractères"
            hasError = true
            return
        }
        if password.count < 8 {
            errorMessage = "Le mot de passe doit contenir au moins 8 caractères"
            hasError = true
            return
        }
        if password != confirmPassword {
            errorMessage = "Les mots de passe ne correspondent pas"
            hasError = true
            return
        }
        
        // Signup
    }
    
    private func isValidEmail() -> Bool {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector?.matches(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count))
        
        return matches?.first?.url?.scheme == "mailto"
    }
}

// MARK: - SignUpPageViewModel mock for preview

extension SignUpPageViewModel {
    static let mock: SignUpPageViewModel = .init(router: SignUpPageRouter.mock)
}
