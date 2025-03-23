//
//  APIService.swift
//  anothapp
//
//  Created by Adrien Garrouste on 23/03/2025.
//


import Foundation

class SearchService {
    
    func fetchImages(limit: Int) async throws -> [String] {
        guard let url = URL(string: "http://localhost:8080/search/images?limit=\(limit)") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([String].self, from: data)
    }
}
