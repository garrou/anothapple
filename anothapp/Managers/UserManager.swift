//
//  UserManager.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/05/2025.
//

import Foundation

class UserManager {

    static let shared = UserManager()
    private let userService = UserService()
    
    func getUsersByUsername(username: String) async -> [Friend] {
        var users: [Friend] = []
        
        do {
            users = try await userService.fetchUsersByUsername(username: username)
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la récupération des amis")
        }
        return users
    }
    
    func updateProfilePicture(image: String) async -> Bool {
        var updated = false
        
        do {
            updated = try await userService.updateProfilePicture(request: .init(image: image))
            
            if updated {
                if var user = SecurityManager.shared.getUser() {
                    user.picture = image
                    updated = SecurityManager.shared.updateUser(user)
                }
            }
            ToastManager.shared.setToast(message: updated ? "Photo de profil modifiée" : "Erreur durant la mise à jour de la photo de profil", isError: !updated)
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la mise à jour de la photo de profil")
        }
        return updated
    }
    
    func updateEmail(email: String, newEmail: String) async -> Bool {
        
        if !Helper.shared.isValidEmail(email) {
            ToastManager.shared.setToast(message: "Email invalide")
            return false
        }
        var updated = false
        
        do {
            updated = try await userService.updateEmail(request: .init(email: email, newEmail: newEmail))
            
            if updated {
                if var user = SecurityManager.shared.getUser() {
                    user.email = newEmail
                    updated = SecurityManager.shared.updateUser(user)
                }
            }
            ToastManager.shared.setToast(message: updated ? "Email modifié" : "Erreur durant la modification de l'email", isError: !updated)
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la modification de l'email")
        }
        return updated
    }
    
    func updatePassword(currentPassword: String, newPassword: String, confirmPassword: String) async -> Bool {
        
        if !Helper.shared.isValidPassword(newPassword) {
            ToastManager.shared.setToast(message: "Le mot de passe doit contenir entre \(Helper.minPassword) et \(Helper.maxPassword) caractères")
            return false
        }
        if newPassword != confirmPassword {
            ToastManager.shared.setToast(message: "Les mots de passe ne correspondent pas")
            return false
        }
        var updated = false
        
        do {
            updated = try await userService.updatePassword(request: .init(currentPassword: currentPassword, newPassword: newPassword, confirmPassword: confirmPassword))
            ToastManager.shared.setToast(message: updated ? "Mot de passe modifié" : "Erreur durant la modification du mot de passe", isError: !updated)
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la modification du mot de passe")
        }
        return updated
    }
}
