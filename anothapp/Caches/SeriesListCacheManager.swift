//
//  SeriesListCacheManager.swift
//  anothapp
//
//  Created by Adrien Garrouste on 01/04/2025.
//

import Foundation

class SeriesListCacheManager {
    
    static let shared = SeriesListCacheManager()
    private let cache = NSCache<NSString, Serie>()
    private let serieService = SerieService()
    private var keys: Set<Int> = []
    
    private func storeSerie(id: Int, value: Serie) {
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
    
    func getSerie(id: Int) -> Serie? {
        cache.object(forKey: String(id) as NSString)
    }
    
    func addSerie(id: Int) async -> Bool {
        let request = SerieRequest(id: id, list: true)
        let (data, added) = (try? await serieService.addSerie(request: request)) ?? (Data(), false)
        
        if !added || data.isEmpty { return false }
        
        if let show = try? JSONDecoder().decode(Serie.self, from: data) {
            storeSerie(id: show.id, value: show)
            return true
        }
        return false
    }
    
    func deleteSerie(id: Int) async -> Bool {
        let removed = (try? await serieService.deleteSerie(id: id, fromList: true)) ?? false
        if removed { self.removeSerie(id: id) }
        return removed
    }
    
    func getSeries() async -> [Serie] {
        let series = keys.compactMap { id in getSerie(id: id) }
        if !series.isEmpty { return series.sorted { $0.title.lowercased() < $1.title.lowercased() } }
        let fetched = (try? await serieService.fetchSeries(status: "not-started")) ?? []
        fetched.forEach { storeSerie(id: $0.id, value: $0) }
        return fetched
    }
}
