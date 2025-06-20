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
    
    private func store(id: Int, value: Serie) {
        cache.setObject(value, forKey: String(id) as NSString)
        keys.insert(id)
    }
    
    private func remove(id: Int) {
        cache.removeObject(forKey: String(id) as NSString)
        keys.remove(id)
    }
    
    private func loadSeries() async -> [Serie] {
        do {
            let fetched = try await serieService.fetchSeries()
            fetched.forEach { store(id: $0.id, value: $0) }
            return fetched
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la récupération des séries")
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
        var isAdded = false
        
        do {
            let (data, added) = try await serieService.addSerie(request: .init(id: id, list: false))
            isAdded = added
            
            if isAdded {
                let show = try JSONDecoder().decode(Serie.self, from: data)
                show.addedAt = Date()
                store(id: show.id, value: show)
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
                remove(id: id)
            } else {
                ToastManager.shared.setToast(message: "Impossible de supprimer la série")
            }
            return deleted
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la suppression")
            return false
        }
    }
    
    func getCountries() -> [String] {
        let series = getAll()
        return Array(Set(series.map { $0.country }))
            .sorted { Helper.shared.compareStrings($0, $1) }
    }
    
    func getSeries(title: String = "", countries: [String] = [], kinds: [Kind] = []) async -> [Serie] {
        var series = getAll()
        if series.isEmpty { series = await loadSeries() }

        if !countries.isEmpty {
            series = series.filter { countries.contains($0.country) }
        }
        if !kinds.isEmpty {
            series = series.filter { Set($0.kinds).intersection(Set(kinds.map { $0.name })).count > 0 }
        }
        return title.isEmpty
        ? series.sorted { $0.addedAt > $1.addedAt }
        : series.filter { Helper.shared.containsString($0.title, title) }
    }
    
    func getFavorites(title: String = "") -> [Serie] {
        let series = getAll().filter { $0.favorite }
        return title.isEmpty
        ? series.sorted { $0.title.lowercased() < $1.title.lowercased() }
        : series.filter { Helper.shared.containsString($0.title, title) }
    }
    
    func getSeriesByWatching(watching: Bool, title: String = "") -> [Serie] {
        let series = getAll().filter { $0.watch == watching }
        return title.isEmpty
        ? series.sorted { $0.title.lowercased() < $1.title.lowercased() }
        : series.filter { Helper.shared.containsString($0.title, title) }
    }
    
    func changeFavorite(serie: Serie) async -> Serie {
        do {
            let updated = try await serieService.updateSerie(id: serie.id, request: .init(favorite: true))
            
            if updated {
                serie.favorite.toggle()
                store(id: serie.id, value: serie)
            }
            ToastManager.shared.setToast(message: updated ? "Favori modifié" : "Favori non modifié", isError: !updated)
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la modification")
        }
        return serie
    }
    
    func changeWatching(serie: Serie) async -> Serie {
        do {
            let updated = try await serieService.updateSerie(id: serie.id, request: .init(watch: true))
            
            if updated {
                serie.watch.toggle()
                store(id: serie.id, value: serie)
            }
            ToastManager.shared.setToast(message: updated ? "Visionage modifiée" : "Visionage non modifié", isError: !updated)
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la modification")
        }
        return serie
    }
    
    func changeAddedAt(serie: Serie, addedAt: Date) async -> Serie {
        do {
            let updated = try await serieService.updateSerie(id: serie.id, request: .init(addedAt: addedAt))
            
            if updated {
                serie.addedAt = addedAt
                store(id: serie.id, value: serie)
            }
            ToastManager.shared.setToast(message: updated ? "Date modifiée" : "Date non modifiée", isError: !updated)
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la modification")
        }
        return serie
    }
    
}
