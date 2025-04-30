//
//  APIService.swift
//  anothapp
//
//  Created by Adrien Garrouste on 23/03/2025.
//


import Foundation

class SearchService {
    
    private let baseUrl = "\(BaseService.serverUrl)/search"
    
    func fetchImages(limit: Int) async throws -> [String] {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)/images?limit=\(limit)")
        return ok ? try JSONDecoder().decode([String].self, from: data) : []
    }
    
    func fetchSuggestions(limit: Int) async throws -> [ApiSerie] {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)/shows?limit=\(limit)")
        return ok ? try JSONDecoder().decode([ApiSerie].self, from: data) : []
    }
    
    func fetchSeriesByFilter(title: String) async throws -> [ApiSeriePreview] {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)/shows?title=\(title)")
        return ok ? try JSONDecoder().decode([ApiSeriePreview].self, from: data) : []
    }
    
    func fetchSerie(id: Int) async throws -> ApiSerie? {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)/shows/\(id)")
        return ok ? try JSONDecoder().decode(ApiSerie.self, from: data) : nil
    }
    
    func fetchSeasonsBySerieId(id: Int) async throws -> [Season] {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)/shows/\(id)/seasons")
        return ok ? try JSONDecoder().decode([Season].self, from: data) : []
    }
    
    func fetchEpisodesBySerieIdBySeason(id: Int, num: Int) async throws -> [Episode] {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)/shows/\(id)/seasons/\(num)/episodes")
        return ok ? try JSONDecoder().decode([Episode].self, from: data) : []
    }
    
    func fetchPlatforms() async throws -> [Platform] {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)/platforms")
        return ok ? try JSONDecoder().decode([Platform].self, from: data) : []
    }
    
    func fetchSimilars(id: Int) async throws -> [BaseSerie] {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)/shows/\(id)/similars")
        return ok ? try JSONDecoder().decode([BaseSerie].self, from: data) : []
    }
    
    func fetchImages(id: Int) async throws -> [String] {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)/shows/\(id)/images")
        return ok ? try JSONDecoder().decode([String].self, from: data) : []
    }
    
    func fetchCharacters(id: Int) async throws -> [Person] {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)/shows/\(id)/characters")
        return ok ? try JSONDecoder().decode([Person].self, from: data) : []
    }
    
    func fetchKinds() async throws -> [Kind] {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)/kinds")
        return ok ? try JSONDecoder().decode([Kind].self, from: data) : []
    }
}
