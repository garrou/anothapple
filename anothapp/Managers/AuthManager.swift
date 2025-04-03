//
//  AuthManager.swift
//  anothapp
//
//  Created by Adrien Garrouste on 03/04/2025.
//

import Foundation

class AuthManager {
    
    static let shared = AuthManager()
    private let authService = AuthService()
    
    func login(identifier: String, password: String) async -> User? {
        
        let request = LoginRequest(identifier: identifier, password: password)
        var user: User? = nil
        
        do {
            user = try await authService.login(loginRequest: request)
            
            if user == nil {
                ToastManager.shared.setToast(message: "Identifiant ou mot de passe incorrect")
            }
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant l'authentification")
        }
        return user
    }
    
    func signup(email: String, username: String, password: String, confirm: String) async -> Bool {
        
        let signUpRequest = SignUpRequest(email: email, username: username, password: password, confirm: confirm)
        var created = false
        
        do {
            created = try await authService.signup(signUpRequest: signUpRequest)
            
            if !created {
                ToastManager.shared.setToast(message: "Erreur durant la création du compte")
            }
        } catch {
            ToastManager.shared.setToast(message: "Une erreur est survenue")
        }
        return created
    }
}
