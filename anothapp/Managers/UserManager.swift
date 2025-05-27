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
    
    func updateProfilePicture(image: String) async {
        do {
            var updated = try await userService.updateProfilePicture(request: .init(image: image))
            
            if (updated) {
                if var user = SecurityManager.shared.getUser() {
                    user.picture = image
                    updated = SecurityManager.shared.updateUser(user)
                }
            }
            ToastManager.shared.setToast(message: updated ? "Photo de profil modifiée" : "Erreur durant la mise à jour de la photo de profil", isError: !updated)
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la mise à jour de la photo de profil")
        }
    }
}
