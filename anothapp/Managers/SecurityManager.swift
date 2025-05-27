//
//  Security.swift
//  anothapp
//
//  Created by Adrien Garrouste on 23/03/2025.
//

import Foundation
import Security

class SecurityManager {
    
    static let shared = SecurityManager()
    private let key = "user_info"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func clearUser() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            ToastManager.shared.setToast(message: "Erreur durant la suppression des informations de l'utilisateur")
        }
    }
    
    func updateUser(_ user: User) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        guard let data = try? encoder.encode(user) else {
            return false
        }
        
        let updateData: [String: Any] = [
            kSecValueData as String: data
        ]
        let updateStatus = SecItemUpdate(query as CFDictionary, updateData as CFDictionary)
        return updateStatus == errSecSuccess
    }
    
    func storeUser(_ user: User) -> Bool {
        var stored = false
        
        do {
            let data = try encoder.encode(user)
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data,
                kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
            ]
            let status = SecItemAdd(query as CFDictionary, nil)
            stored = status == errSecSuccess
            
            if !stored {
                ToastManager.shared.setToast(message: "Erreur, données de l'utilisateur non stockées")
            }
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant le stockage de l'utilisateur")
        }
        return stored
    }
    
    func getUser() -> User? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let retrievedData = result as? Data {
            do {
                return try decoder.decode(User.self, from: retrievedData)
            } catch {
                ToastManager.shared.setToast(message: "Données utilisateur non valides")
            }
        } else {
            ToastManager.shared.setToast(message: "Erreur durant la récupération du profil")
        }
        return nil
    }
    
    func isLoggedIn() -> Bool {
        getUser() != nil
    }
}
