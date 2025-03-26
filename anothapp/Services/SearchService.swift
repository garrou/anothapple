//
//  APIService.swift
//  anothapp
//
//  Created by Adrien Garrouste on 23/03/2025.
//


import Foundation

class SearchService {
    
    private let baseUrl = "http://localhost:8080/search"
    private let session = URLSession(configuration: URLSessionConfiguration.default, delegate: HTTPInterceptor.shared, delegateQueue: nil)
    
    func fetchImages(limit: Int) async throws -> [String] {
        guard let url = URL(string: "\(baseUrl)/images?limit=\(limit)") else {
            throw URLError(.badURL)
        }
        let request = HTTPInterceptor.shared.interceptRequest(URLRequest(url: url))
        let (data, response) = try await session.data(for: request)
        let ok = (response as? HTTPURLResponse)?.statusCode == 200
        return ok ? try JSONDecoder().decode([String].self, from: data) : []
    }
    
    func fetchSuggestions(limit: Int) async throws -> [ApiSerie] {
        guard let url = URL(string: "\(baseUrl)/shows?limit=\(limit)") else {
            throw URLError(.badURL)
        }
        let request = HTTPInterceptor.shared.interceptRequest(URLRequest(url: url))
        let (data, response) = try await session.data(for: request)
        let ok = (response as? HTTPURLResponse)?.statusCode == 200
        return ok ? try JSONDecoder().decode([ApiSerie].self, from: data) : []
    }
}
