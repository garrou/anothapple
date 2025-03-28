//
//  SerieService.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import Foundation

class SerieService {
    
    private let baseUrl = "http://localhost:8080/shows"
    private let session = URLSession(configuration: URLSessionConfiguration.default, delegate: HTTPInterceptor.shared, delegateQueue: nil)
    
    func fetchSeries() async throws -> [Serie] {
        guard let url = URL(string: baseUrl) else {
            throw URLError(.badURL)
        }
        let request = HTTPInterceptor.shared.interceptRequest(URLRequest(url: url))
        let (data, response) = try await session.data(for: request)
        let ok = (response as? HTTPURLResponse)?.statusCode == 200
        return ok ? try JSONDecoder().decode([Serie].self, from: data) : []
    }
    
    func fetchFavorites() async throws -> [Serie] {
        guard let url = URL(string: "\(baseUrl)?status=favorite") else {
            throw URLError(.badURL)
        }
        let request = HTTPInterceptor.shared.interceptRequest(URLRequest(url: url))
        let (data, response) = try await session.data(for: request)
        let ok = (response as? HTTPURLResponse)?.statusCode == 200
        return ok ? try JSONDecoder().decode([Serie].self, from: data) : []
    }
}
