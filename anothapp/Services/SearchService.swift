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
        guard let url = URL(string: "\(baseUrl)/images?limit=\(limit)") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([String].self, from: data)
    }
}
