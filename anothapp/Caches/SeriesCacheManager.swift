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
    private var keys: Set<Int> = []
    private let serieService = SerieService()

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
        let request = SerieRequest(id: id, list: false)
        var isAdded = false
        
        do {
            let (data, added) = try await serieService.addSerie(request: request)
            isAdded = added
            
            if isAdded {
                let show = try JSONDecoder().decode(Serie.self, from: data)
                show.addedAt = Date()
                storeSerie(id: show.id, value: show)
            }
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant l'ajout")
            return false
        }
        ToastManager.shared.setToast(message: isAdded ? "Série ajoutée" : "Impossible d'ajouter la série", isError: !isAdded)
        return isAdded
    }
    
    func deleteSerie(id: Int) async -> Bool {
        do {
            let deleted = try await serieService.deleteSerie(id: id)
            
            if deleted {
                self.removeSerie(id: id)
            } else {
                ToastManager.shared.setToast(message: "Impossible de supprimer la série")
            }
            return deleted
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la suppression")
            return false
        }
    }
    
    func getSeries(title: String) async -> [Serie] {
        let series = keys.compactMap { id in getSerie(id: id) }
        
        if !series.isEmpty {
            let stored = series.sorted { $0.addedAt > $1.addedAt }
            return title.isEmpty ? stored : stored.filter { $0.title.lowercased().contains(title.lowercased()) }
        }
        
        do {
            let fetched = try await serieService.fetchSeries()
            fetched.forEach { storeSerie(id: $0.id, value: $0) }
            return fetched
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la récupération de vos séries")
            return []
        }
    }
    
    func getFavorites() -> [Serie] {
        let series = keys.compactMap { id in getSerie(id: id) }
        return series.filter { $0.favorite }.sorted { $0.title.lowercased() < $1.title.lowercased() }
    }
    
    func getSeriesByWatching(watching: Bool) -> [Serie] {
        let series = keys.compactMap { id in getSerie(id: id) }
        return series.filter { $0.watch == watching }.sorted { $0.title.lowercased() < $1.title.lowercased() }
    }
    
    func changeFavorite(serie: Serie) async -> Serie {
        let request = StatusRequest(favorite: true, watch: nil)
        
        do {
            if try await serieService.changeFavorite(id: serie.id, request: request) {
                serie.favorite.toggle()
                storeSerie(id: serie.id, value: serie)
            }
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la modification")
        }
        return serie
    }
    
    func changeWatching(serie: Serie) async -> Serie {
        let request = StatusRequest(favorite: nil, watch: true)
        
        do {
            if try await serieService.changeWatching(id: serie.id, request: request) {
                serie.watch.toggle()
                storeSerie(id: serie.id, value: serie)
            }
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la modification")
        }
        return serie
    }

}
