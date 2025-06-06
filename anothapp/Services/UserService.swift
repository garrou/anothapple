//
//  UserService.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/05/2025.
//

import Foundation

class UserService {
    
    private let baseUrl = "\(BaseService.serverUrl)/users"
    private let decoder: JSONDecoder = JSONDecoder()
    
    func fetchUsersByUsername(username: String) async throws -> [Friend] {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)?username=\(username)")
        return ok ? try decoder.decode([Friend].self, from: data) : []
    }
    
    func updateProfilePicture(request: ProfilePictureRequest) async throws -> Bool {
        let (_, ok) = try await BaseService.shared.dataRequest(url: "\(baseUrl)/me", method: "PATCH", data: request)
        return ok
    }
    
    func updateEmail(request: ProfileEmailRequest) async throws -> Bool {
        let (_, ok) = try await BaseService.shared.dataRequest(url: "\(baseUrl)/me", method: "PATCH", data: request)
        return ok
    }
    
    func updatePassword(request: ProfilePasswordRequest) async throws -> Bool {
        let (_, ok) = try await BaseService.shared.dataRequest(url: "\(baseUrl)/me", method: "PATCH", data: request)
        return ok
    }
}
