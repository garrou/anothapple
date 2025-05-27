//
//  SeasonService.swift
//  anothapp
//
//  Created by Adrien Garrouste on 04/04/2025.
//

import Foundation

class SeasonService {
    
    private let baseUrl = "\(BaseService.serverUrl)/seasons"
    private let decoder: JSONDecoder = JSONDecoder()
    
    func fetchSeasonsMonthAgo(month: Int) async throws -> [Timeline] {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)?month=\(month)")
        return ok ? try decoder.decode([Timeline].self, from: data) : []
    }
    
    func fetchSeasonsByYear(year: Int) async throws -> [Timeline] {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)?year=\(year)")
        return ok ? try decoder.decode([Timeline].self, from: data) : []
    }
    
    func updateSeason(request: PlatformRequest) async throws -> Bool {
        let (_, ok) = try await BaseService.shared.dataRequest(url: "\(baseUrl)/\(request.id)", method: "PATCH", data: request)
        return ok
    }
    
    func deleteSeason(id: Int) async throws -> Bool {
        let (_, ok) = try await BaseService.shared.request(url: "\(baseUrl)/\(id)", method: "DELETE", successCode: 204)
        return ok
    }
}
