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

    private func store(id: Int, value: ApiSerie) {
        cache.setObject(value, forKey: String(id) as NSString)
        keys.insert(id)
    }
    
    private func remove(id: Int) {
        cache.removeObject(forKey: String(id) as NSString)
        keys.remove(id)
    }
    
    private func getById(id: Int) -> ApiSerie? {
        cache.object(forKey: String(id) as NSString)
    }
    
    private func getAll() -> [ApiSerie] {
        keys.compactMap { id in getById(id: id) }
    }
    
    func getSerie(id: Int) async -> ApiSerie? {
        if let serie = getById(id: id) { return serie }
        
        do {
            let fetched = try await searchService.fetchSerie(id: id)
            if fetched != nil { store(id: fetched!.id, value: fetched!) }
            return fetched
        } catch {
            ToastManager.shared.setToast(message: "Erreur lors du chargement de la série")
            return nil
        }
    }
    
    func getSeries(limit: Int = 20) async -> [ApiSerie] {
        let series = getAll()
        if !series.isEmpty { return series.sorted { $0.id > $1.id } }
        var fetched: [ApiSerie] = []
        
        do {
            fetched = try await searchService.fetchSuggestions(limit: limit)
            fetched.forEach { store(id: $0.id, value: $0) }
        } catch {
            ToastManager.shared.setToast(message: "Erreur lors du chargement des séries")
        }
        return fetched
    }
}
