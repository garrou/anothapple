//
//  SeriesCache.swift
//  anothapp
//
//  Created by Adrien Garrouste on 28/03/2025.
//

import Foundation

class SeriesCacheManager {

    static let shared = SeriesCacheManager()
    private let cache = NSCache<NSString, Serie>()
    private var keys: Set<String> = []
    private let serieService = SerieService()

    func storeSerie(key: String, value: Serie) {
        cache.setObject(value, forKey: key as NSString)
        keys.insert(key)
    }

    func getSerie(key: String) async -> Serie? {
        if let cached = cache.object(forKey: key as NSString) {
            return cached
        }
        return try? await serieService.fetchSerie(id: Int(key) ?? 0)
    }
    
    func removeSerie(key: String) async -> Bool {
        let deleted = (try? await serieService.deleteSerie(id: Int(key) ?? 0)) ?? false
        
        if deleted {
            cache.removeObject(forKey: key as NSString)
            keys.remove(key)
        }
        return deleted
    }
    
    func getSeries() async -> [Serie] {
        let series = keys.compactMap { key in
            cache.object(forKey: key as NSString) as Serie?
        }
        if !series.isEmpty {
            return series
        }
        let fetched = (try? await serieService.fetchSeries()) ?? []
        fetched.forEach { storeSerie(key: String($0.id), value: $0) }
        return fetched.sorted { $0.addedAt > $1.addedAt }
    }
    
    func getFavorites() -> [Serie] {
        let series = keys.compactMap { key in
            cache.object(forKey: key as NSString) as Serie?
        }
        return series.filter { $0.favorite }.sorted { $0.title.lowercased() < $1.title.lowercased() }
    }
    
    func changeFavorite(serie: Serie) async -> Serie {
        let request = StatusRequest(favorite: true, watch: nil)
        let updated = (try? await serieService.changeFavorite(id: serie.id, request: request)) ?? false
        
        if updated {
            serie.favorite.toggle()
            storeSerie(key: String(serie.id), value: serie)
        }
        return serie
    }
    
    func changeWatching(serie: Serie) async -> Serie {
        let request = StatusRequest(favorite: nil, watch: true)
        let updated = (try? await serieService.changeWatching(id: serie.id, request: request)) ?? false
        
        if updated {
            serie.watch.toggle()
            storeSerie(key: String(serie.id), value: serie)
        }
        return serie
    }
}
