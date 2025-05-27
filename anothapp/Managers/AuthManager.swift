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
    
    func login(identifier: String, password: String) async -> Bool {
        do {
            if let user = try await authService.login(loginRequest: .init(identifier: identifier, password: password)) {
                return SecurityManager.shared.storeUser(user)
            } else {
                ToastManager.shared.setToast(message: "Identifiant ou mot de passe incorrect")
            }
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant l'authentification")
        }
        return false
    }
    
    func signup(email: String, username: String, password: String, confirm: String) async -> Bool {
        var created = false
        
        do {
            created = try await authService.signup(signUpRequest: .init(email: email, username: username, password: password, confirm: confirm))
            
            if !created {
                ToastManager.shared.setToast(message: "Erreur durant la création du compte")
            }
        } catch {
            ToastManager.shared.setToast(message: "Une erreur est survenue")
        }
        return created
    }
}
