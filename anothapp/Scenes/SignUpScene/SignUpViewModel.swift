//
//  SignUpPageViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 21/03/2025.
//

import Foundation

class SignUpViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    private let router: SignUpRouter
    
    var isInvalidForm: Bool {
        email.isEmpty || username.isEmpty || password.isEmpty || confirmPassword.isEmpty
    }
    
    init(router: SignUpRouter) {
        self.router = router
    }
    
    func navigateToLoginPage() {
        router.routeToLoginPage()
    }
    
    func performSignUp() async {
        if !isValidEmail() {
            ToastManager.shared.setToast(message: "Email invalide")
            return
        }
        if username.count < 3 {
            ToastManager.shared.setToast(message: "Le nom d'utilisateur doit contenir au moins 3 caractères")
            return
        }
        if password.count < 8 {
            ToastManager.shared.setToast(message: "Le mot de passe doit contenir au moins 8 caractères")
            return
        }
        if password != confirmPassword {
            ToastManager.shared.setToast(message: "Les mots de passe ne correspondent pas")
            return
        }
        if await AuthManager.shared.signup(email: email, username: username, password: password, confirm: confirmPassword) {
            router.routeToLoginPage()
        }
    }
    
    private func isValidEmail() -> Bool {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector?.matches(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count))
        return matches?.first?.url?.scheme == "mailto"
    }
}

// MARK: - SignUpViewModel mock for preview

extension SignUpViewModel {
    static let mock: SignUpViewModel = .init(router: SignUpRouter.mock)
}
