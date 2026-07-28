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
    private let service = Bundle.main.bundleIdentifier ?? "anothapp"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private var baseQuery: [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: service
        ]
    }
    
    func clearUser() {
        let status = SecItemDelete(baseQuery as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            ToastManager.shared.setToast(message: "Erreur durant la suppression des informations de l'utilisateur")
        }
    }
    
    func updateUser(_ user: User) -> Bool {
        guard let data = try? encoder.encode(user) else { return false }
        let updateData: [String: Any] = [kSecValueData as String: data]
        let updateStatus = SecItemUpdate(baseQuery as CFDictionary, updateData as CFDictionary)
        return updateStatus == errSecSuccess
    }
    
    func storeUser(_ user: User) -> Bool {
        do {
            let data = try encoder.encode(user)
            var query = baseQuery
            query[kSecValueData as String] = data
            query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked
            
            let status = SecItemAdd(query as CFDictionary, nil)
            let stored: Bool
            
            if status == errSecDuplicateItem {
                stored = updateUser(user)
            } else {
                stored = status == errSecSuccess
            }
            
            if !stored {
                ToastManager.shared.setToast(message: "Erreur, données de l'utilisateur non stockées")
            }
            return stored
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant le stockage de l'utilisateur")
            return false
        }
    }
    
    func getUser() -> User? {
        var query = baseQuery
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = true
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let retrievedData = result as? Data {
            do {
                return try decoder.decode(User.self, from: retrievedData)
            } catch {
                ToastManager.shared.setToast(message: "Données utilisateur non valides")
            }
        }
        return nil
    }
    
    func isLoggedIn() -> Bool {
        getUser() != nil
    }
}
