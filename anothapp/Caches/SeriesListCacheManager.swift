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
    
    private func store(id: Int, value: Serie) {
        cache.setObject(value, forKey: String(id) as NSString)
        keys.insert(id)
    }
    
    private func remove(id: Int) {
        cache.removeObject(forKey: String(id) as NSString)
        keys.remove(id)
    }
    
    private func loadWatchList() async -> [Serie] {
        do {
            let fetched = try await serieService.fetchSeries(status: .watchlist)
            fetched.forEach { store(id: $0.id, value: $0) }
            return fetched
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la récupération des séries de la liste")
            return []
        }
    }
    
    private func getAll() -> [Serie] {
        keys.compactMap { id in getById(id: id) }
    }
    
    func clear() {
        cache.removeAllObjects()
        keys.removeAll()
    }
    
    func getById(id: Int) -> Serie? {
        cache.object(forKey: String(id) as NSString)
    }
    
    func isAlreadyAdded(id: Int) -> Bool {
        getById(id: id) != nil
    }
    
    func addSerie(id: Int) async -> Bool {        
        do {
            let (data, added) = try await serieService.addSerie(request: .init(id: id, list: true))
            if !added { return false }
            let show = try JSONDecoder().decode(Serie.self, from: data)
            store(id: show.id, value: show)
            return true
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant l'ajout")
            return false
        }
    }
    
    func deleteSerie(id: Int) async -> Bool {
        do {
            let removed = try await serieService.deleteSerie(id: id, fromList: true)
            if removed { remove(id: id) }
            return removed
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la suppression")
            return false
        }
    }
    
    func getWatchList(title: String = "") async -> [Serie] {
        var series = getAll()
        if series.isEmpty { series = await loadWatchList() }
        return title.isEmpty
        ? series.sorted { $0.title.lowercased() < $1.title.lowercased() }
        : series.filter { Helper.shared.containsString($0.title, title) }
    }
}
