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
        let (data, added) = (try? await serieService.addSerie(request: request)) ?? (Data(), false)
        
        if !added || data.isEmpty { return false }
        
        if let show = try? JSONDecoder().decode(Serie.self, from: data) {
            show.addedAt = Date()
            storeSerie(id: show.id, value: show)
            return true
        }
        return false
    }
    
    func deleteSerie(id: Int) async -> Bool {
        let deleted = (try? await serieService.deleteSerie(id: id)) ?? false
        if deleted { self.removeSerie(id: id) }
        return deleted
    }
    
    func getSerieInfos(id: Int) async -> SerieInfos {
        let infos = try? await serieService.fetchSerieInfos(id: id)
        return infos ?? .init(seasons: [], time: 0, episodes: 0)
    }
    
    func getSeries(title: String) async -> [Serie] {
        let series = keys.compactMap { id in getSerie(id: id) }
        if !series.isEmpty {
            let stored = series.sorted { $0.addedAt > $1.addedAt }
            return title.isEmpty ? stored : stored.filter { $0.title.lowercased().contains(title.lowercased()) }
        }
        let fetched = (try? await serieService.fetchSeries(status: nil)) ?? []
        fetched.forEach { storeSerie(id: $0.id, value: $0) }
        return fetched
    }
    
    func getFavorites() -> [Serie] {
        let series = keys.compactMap { id in getSerie(id: id) }
        return series.filter { $0.favorite }.sorted { $0.title.lowercased() < $1.title.lowercased() }
    }
    
    func changeFavorite(serie: Serie) async -> Serie {
        let request = StatusRequest(favorite: true, watch: nil)
        let updated = (try? await serieService.changeFavorite(id: serie.id, request: request)) ?? false
        
        if updated {
            serie.favorite.toggle()
            storeSerie(id: serie.id, value: serie)
        }
        return serie
    }
    
    func changeWatching(serie: Serie) async -> Serie {
        let request = StatusRequest(favorite: nil, watch: true)
        let updated = (try? await serieService.changeWatching(id: serie.id, request: request)) ?? false
        
        if updated {
            serie.watch.toggle()
            storeSerie(id: serie.id, value: serie)
        }
        return serie
    }
    
    func addSeason(id: Int, season: Season) async -> Bool {
        let request = SeasonRequest(id: id, num: season.number)
        return (try? await serieService.addSeason(request: request)) ?? false
    }
}
