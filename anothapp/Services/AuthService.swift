//
//  AuthService.swift
//  anothapp
//
//  Created by Adrien Garrouste on 23/03/2025.
//

import Foundation

class AuthService {
    
    private let baseUrl = "\(BaseService.serverUrl)/auth"
    private let encoder: JSONEncoder = JSONEncoder()
    
    func signup(signUpRequest: SignUpRequest) async throws -> Bool {
        guard let url = URL(string: "\(baseUrl)/register") else {
            return false
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try encoder.encode(signUpRequest)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        return (response as? HTTPURLResponse)?.statusCode == 201
    }
    
    func login(loginRequest: LoginRequest) async throws -> User? {
        guard let url = URL(string: "\(baseUrl)/login") else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try encoder.encode(loginRequest)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let authenticated = (response as? HTTPURLResponse)?.statusCode == 200
        return authenticated ? try JSONDecoder().decode(User.self, from: data) : nil
    }
}
