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
    private var keys: Set<Int> = []
    private let searchService = SearchService()

    private func storeSerie(id: Int, value: ApiSerie) {
        cache.setObject(value, forKey: String(id) as NSString)
        keys.insert(id)
    }
    
    private func removeSerie(id: Int) {
        cache.removeObject(forKey: String(id) as NSString)
        keys.remove(id)
    }
    
    private func getFromCache(id: Int) -> ApiSerie? {
        cache.object(forKey: String(id) as NSString)
    }
    
    func getSerie(id: Int) async -> ApiSerie? {
        if let serie = cache.object(forKey: String(id) as NSString) { return serie }
        
        do {
            return try await searchService.fetchSerie(id: id)
        } catch {
            ToastManager.shared.setToast(message: "Erreur lors du chargement de la série")
            return nil
        }
    }
    
    func getSeries(limit: Int) async -> [ApiSerie] {
        let series = keys.compactMap { id in getFromCache(id: id) }
        if !series.isEmpty { return series.sorted { $0.id > $1.id } }
        var fetched: [ApiSerie] = []
        
        do {
            fetched = try await searchService.fetchSuggestions(limit: limit)
            fetched.forEach { storeSerie(id: $0.id, value: $0) }
        } catch {
            ToastManager.shared.setToast(message: "Erreur lors du chargement des séries")
        }
        return fetched
    }
}
