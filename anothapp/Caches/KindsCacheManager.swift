//
//  SeriesCache.swift
//  anothapp
//
//  Created by Adrien Garrouste on 28/03/2025.
//

import Foundation

class KindsCacheManager {
    
    static let shared = KindsCacheManager()
    private let cache = NSCache<NSString, Kind>()
    private var keys: Set<String> = []
    private let searchService = SearchService()
    
    private func store(id: String, value: Kind) {
        cache.setObject(value, forKey: id as NSString)
        keys.insert(id)
    }
    
    private func remove(id: String) {
        cache.removeObject(forKey: id as NSString)
        keys.remove(id)
    }
    
    private func loadKinds() async -> [Kind] {
        do {
            let fetched = try await searchService.fetchKinds()
            fetched.forEach { store(id: $0.value, value: $0) }
            return fetched
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la récupération des genres")
            return []
        }
    }
    
    private func getAll() -> [Kind] {
        keys.compactMap { id in getById(id: id) }
    }
    
    func clear() {
        cache.removeAllObjects()
        keys.removeAll()
    }
    
    func getById(id: String) -> Kind? {
        cache.object(forKey: id as NSString)
    }
    
    func getKinds() async -> [Kind] {
        var kinds = getAll()
        if kinds.isEmpty { kinds = await loadKinds() }
        return kinds.sorted { Helper.shared.compareStrings($0.name, $1.name) }
    }
}
