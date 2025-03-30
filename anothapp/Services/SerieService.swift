//
//  SerieService.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import Foundation

class SerieService {
    
    private let baseUrl = "http://localhost:8080/shows"
    private let decoder: JSONDecoder = JSONDecoder()
    
    func fetchSeries() async throws -> [Serie] {
        let (data, ok) = try await BaseService.shared.request(url: baseUrl)
        return ok ? try decoder.decode([Serie].self, from: data) : []
    }
    
    func fetchSerieInfos(id: Int) async throws -> SerieInfos? {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)/\(id)")
        return ok ? try? decoder.decode(SerieInfos.self, from: data) : nil
    }
    
    func fetchFavorites() async throws -> [Serie] {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)?status=favorite")
        return ok ? try decoder.decode([Serie].self, from: data) : []
    }
    
    func changeFavorite(id: Int, request: StatusRequest) async throws -> Bool {
        try await BaseService.shared.updateRequest(url: "\(baseUrl)/\(id)", method: "PATCH", data: request)
    }
    
    func changeWatching(id: Int, request: StatusRequest) async throws -> Bool {
        try await BaseService.shared.updateRequest(url: "\(baseUrl)/\(id)", method: "PATCH", data: request)
    }
    
    func deleteSerie(id: Int) async throws -> Bool {
        let (_, ok) = try await BaseService.shared.request(url: "\(baseUrl)/\(id)", method: "DELETE", successCode: 204)
        return ok
    }
}
