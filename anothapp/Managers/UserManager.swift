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
}
