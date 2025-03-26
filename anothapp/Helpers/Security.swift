//
//  Security.swift
//  anothapp
//
//  Created by Adrien Garrouste on 23/03/2025.
//

import Foundation
import Security

class SecurityHelper {
    
    static private let key = "user_info"
    
    static func clearUser() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            print("Keychain item deleted successfully.")
        } else {
            print("Failed to delete item: \(status)")
        }
    }
    
    static func storeUser(_ user: User) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(user)
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data,
                kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
            ]
            let status = SecItemAdd(query as CFDictionary, nil)
            
            if status == errSecSuccess {
                print("User data stored successfully.")
            } else {
                print("Error storing user data: \(status)")
            }
        } catch {
            print("Error during encoding user data: \(error)")
        }
    }
    
    static func getUser() -> User? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let retrievedData = result as? Data {
            let decoder = JSONDecoder()
            do {
                return try decoder.decode(User.self, from: retrievedData)
            } catch {
                print("Error decoding user data: \(error)")
            }
        } else {
            print("Error retrieving item from Keychain: \(status)")
        }
        return nil
    }
}
