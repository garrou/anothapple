//
//  PlatformsCacheManager.swift
//  anothapp
//
//  Created by Adrien Garrouste on 04/04/2025.
//

import Foundation

class PlatformsCacheManager {
    
    static let shared = PlatformsCacheManager()
    private let cache = NSCache<NSString, Platform>()
    private var keys: Set<Int> = []
    private let searchService = SearchService()
    
    private func store(id: Int, value: Platform) {
        cache.setObject(value, forKey: String(id) as NSString)
        keys.insert(id)
    }
    
    private func remove(id: Int) {
        cache.removeObject(forKey: String(id) as NSString)
        keys.remove(id)
    }
    
    private func loadPlatforms() async -> [Platform] {
        do {
            let fetched = try await searchService.fetchPlatforms()
            fetched.forEach { store(id: $0.id!, value: $0) }
            return fetched
        } catch {
            ToastManager.shared.setToast(message: "Erreur lors du chargement des plateformes")
            return []
        }
    }
    
    private func getAll() -> [Platform] {
        keys.compactMap { id in getById(id: id) }
    }
    
    func clear() {
        cache.removeAllObjects()
        keys.removeAll()
    }
    
    func getById(id: Int) -> Platform? {
        cache.object(forKey: String(id) as NSString)
    }
    
    func getPlatforms() async -> [Platform] {
        var platforms = getAll()
        if platforms.isEmpty { platforms = await loadPlatforms() }
        return platforms
    }
}
