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
    @Published var showingLoginError = false
    @Published var errorMessage = ""
    
    private let router: LoginPageRouter
    
    init(router: LoginPageRouter) {
        self.router = router
    }
    
    func navigateToSignUpPage() {
        router.routeToSignUpPage()
    }
    
    func performLogin() {
        
    }
}

// MARK: - LoginPageViewModel mock for preview

extension LoginPageViewModel {
    static let mock: LoginPageViewModel = .init(router: LoginPageRouter.mock)
}
