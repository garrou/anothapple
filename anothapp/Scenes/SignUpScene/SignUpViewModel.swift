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
        email.isEmpty
        || username.isEmpty
        || password.isEmpty || confirmPassword.isEmpty || !Helper.shared.isValidPassword(password) || password != confirmPassword
        || !Helper.shared.isValidEmail(email)
    }
    
    init(router: SignUpRouter) {
        self.router = router
    }
    
    func navigateToLoginPage() {
        router.routeToLoginPage()
    }
    
    func performSignUp() async {
        if isInvalidForm { return }
        if await AuthManager.shared.signup(email: email, username: username, password: password, confirm: confirmPassword) {
            router.routeToLoginPage()
        }
    }
}

// MARK: - SignUpViewModel mock for preview

extension SignUpViewModel {
    static let mock: SignUpViewModel = .init(router: SignUpRouter.mock)
}
