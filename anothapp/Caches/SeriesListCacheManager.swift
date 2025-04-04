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
        
        do {
            let (data, added) = try await serieService.addSerie(request: request)
            if !added { return false }
            let show = try JSONDecoder().decode(Serie.self, from: data)
            storeSerie(id: show.id, value: show)
            return true
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant l'ajout")
            return false
        }
    }
    
    func deleteSerie(id: Int) async -> Bool {
        do {
            let removed = try await serieService.deleteSerie(id: id, fromList: true)
            if removed { self.removeSerie(id: id) }
            return removed
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la suppression")
            return false
        }
    }
    
    func getWatchList() -> [Serie] {
        let series = keys.compactMap { id in getSerie(id: id) }
        return series.sorted { $0.title.lowercased() < $1.title.lowercased() }
    }
    
    func loadWatchList() async -> [Serie] {
        let series = getWatchList()
        if !series.isEmpty { return series }
        
        do {
            let fetched = try await serieService.fetchSeries(status: "watchlist")
            fetched.forEach { storeSerie(id: $0.id, value: $0) }
            return fetched
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la récupération des séries de la liste")
            return []
        }
    }
}
