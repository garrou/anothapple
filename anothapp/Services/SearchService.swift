//
//  APIService.swift
//  anothapp
//
//  Created by Adrien Garrouste on 23/03/2025.
//


import Foundation

class SearchService {
    
    private let baseUrl = "http://localhost:8080/search"
    
    func fetchImages(limit: Int) async throws -> [String] {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)/images?limit=\(limit)")
        return ok ? try JSONDecoder().decode([String].self, from: data) : []
    }
    
    func fetchSuggestions(limit: Int) async throws -> [ApiSerie] {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)/shows?limit=\(limit)")
        return ok ? try JSONDecoder().decode([ApiSerie].self, from: data) : []
    }
    
    func fetchSerie(id: Int) async throws -> ApiSerie? {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)/shows/\(id)")
        return ok ? try JSONDecoder().decode(ApiSerie.self, from: data) : nil
    }
    
    func fetchSeasonsBySerieId(id: Int) async throws -> [Season] {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)/shows/\(id)/seasons")
        return ok ? try JSONDecoder().decode([Season].self, from: data) : []
    }
}
