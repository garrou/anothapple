//
//  StatService.swift
//  anothapp
//
//  Created by Adrien Garrouste on 11/04/2025.
//

import Foundation

class StatService {
    
    private let baseUrl = "\(BaseService.serverUrl)/stats"
    private let decoder: JSONDecoder = JSONDecoder()
    
    func getUserStats(userId: String? = nil) async throws -> UserStat? {
        let url = userId == nil ? baseUrl : "\(baseUrl)?id=\(userId!)"
        let (data, ok) = try await BaseService.shared.request(url: url)
        return ok ? try decoder.decode(UserStat.self, from: data) : nil
    }
}
