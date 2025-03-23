//
//  AuthService.swift
//  anothapp
//
//  Created by Adrien Garrouste on 23/03/2025.
//

import Foundation

class AuthService {
    
    private let baseUrl = "http://localhost:8080/auth"
    
    func signup(signUpModel: SignUpModel) async -> Bool {
        guard let url = URL(string: "\(baseUrl)/register") else {
            return false
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(signUpModel)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            return (response as? HTTPURLResponse)?.statusCode == 201
        } catch {
            return false
        }
    }
    
    func login(loginModel: LoginModel) async -> Bool {
        guard let url = URL(string: "\(baseUrl)/login") else {
            return false
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(loginModel)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            return (response as? HTTPURLResponse)?.statusCode == 200
        } catch {
            return false
        }
    }
}
