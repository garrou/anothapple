//
//  ApiSerieCacheManager.swift
//  anothapp
//
//  Created by Adrien Garrouste on 28/03/2025.
//

import Foundation

class ApiSeriesCacheManager {

    static let shared = ApiSeriesCacheManager()
    private let cache = NSCache<NSString, ApiSerie>()
    private var keys: Set<String> = []
    private let searchService = SearchService()

    private func storeSerie(key: String, value: ApiSerie) {
        cache.setObject(value, forKey: key as NSString)
        keys.insert(key)
    }
    
    private func removeSerie(key: String) {
        cache.removeObject(forKey: key as NSString)
        keys.remove(key)
    }
    
    func getSerie(id: Int) async -> ApiSerie? {
        if let cached = cache.object(forKey: String(id) as NSString) { return cached }
        
        do {
            return try await searchService.fetchSerie(id: id)
        } catch {
            ToastManager.shared.setToast(message: "Erreur lors du chargement de la série")
            return nil
        }
    }
    
    func getSeries(limit: Int) async -> [ApiSerie] {
        let series = keys.compactMap { key in cache.object(forKey: key as NSString) as ApiSerie? }
        if !series.isEmpty { return series.sorted { $0.id > $1.id } }
        var fetched: [ApiSerie] = []
        
        do {
            fetched = try await searchService.fetchSuggestions(limit: limit)
            fetched.forEach { storeSerie(key: String($0.id), value: $0) }
        } catch {
            ToastManager.shared.setToast(message: "Erreur lors du chargement des séries")
        }
        return fetched
    }
}
