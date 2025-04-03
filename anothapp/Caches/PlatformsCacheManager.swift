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
    
    private func storePlatform(id: Int, value: Platform) {
        cache.setObject(value, forKey: String(id) as NSString)
        keys.insert(id)
    }
    
    private func removeSerie(id: Int) {
        cache.removeObject(forKey: String(id) as NSString)
        keys.remove(id)
    }
    
    func clear() {
        cache.removeAllObjects()
        keys.removeAll()
    }
    
    func getPlatform(id: Int) -> Platform? {
        cache.object(forKey: String(id) as NSString)
    }
    
    func getPlatforms() async -> [Platform] {
        let platforms = keys.compactMap { id in getPlatform(id: id) }
        if !platforms.isEmpty { return platforms }
        
        do {
            let fetched = try await searchService.fetchPlatforms()
            fetched.forEach { storePlatform(id: $0.id!, value: $0) }
            return fetched
        } catch {
            print(error)
            ToastManager.shared.setToast(message: "Erreur lors du chargement des plateformes")
            return []
        }
    }
}
