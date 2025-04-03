//
//  SignUpPageViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 21/03/2025.
//

import Foundation

class SignUpViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String = ""
    @Published var hasError = false
    
    private let router: SignUpRouter
    private let authService = AuthService()
    
    var isInvalidForm: Bool {
        email.isEmpty || username.isEmpty || password.isEmpty || confirmPassword.isEmpty
    }
    
    init(router: SignUpRouter) {
        self.router = router
    }
    
    func navigateToLoginPage() {
        router.routeToLoginPage()
    }
    
    @MainActor
    func performSignUp() async {
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
        
        let signUpRequest = SignUpRequest(email: email, username: username, password: password, confirm: confirmPassword)
        do {
            let created = try await authService.signup(signUpRequest: signUpRequest)
            
            if created {
                router.routeToLoginPage()
            }
        } catch {
            errorMessage = "Une erreur est survenue"
        }
    }
    
    private func isValidEmail() -> Bool {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector?.matches(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count))
        return matches?.first?.url?.scheme == "mailto"
    }
}

// MARK: - SignUpPageViewModel mock for preview

extension SignUpViewModel {
    static let mock: SignUpViewModel = .init(router: SignUpRouter.mock)
}
