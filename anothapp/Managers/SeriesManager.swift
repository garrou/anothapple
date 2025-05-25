//
//  SeriesManager.swift
//  anothapp
//
//  Created by Adrien Garrouste on 03/04/2025.
//

import Foundation

class SeriesManager {
    
    static let shared = SeriesManager()
    private let serieService = SerieService()
    
    func addSeason(id: Int, season: Season) async -> Bool {
        var added = false
        
        do {
            added = try await serieService.addSeason(request: .init(id: id, num: season.number))
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant l'ajout de la saison")
        }
        
        ToastManager.shared.setToast(message: added ? "Saison ajoutée" : "Impossible d'ajouter la saison", isError: !added)
        return added
    }
    
    func getSerieInfos(id: Int) async -> SerieInfos {
        var infos: SerieInfos = .init(seasons: [], time: 0, episodes: 0)
        
        do {
            if let fetched = try await serieService.fetchSerieInfos(id: id) {
                infos = fetched
            }
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la récupération des informations")
        }
        return infos
    }
    
    func getSeasonDetails(id: Int, num: Int) async -> [SeasonInfos] {
        do {
            return try await serieService.fetchSeasonInfos(id: id, num: num)
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la récupération des détails")
            return []
        }
    }
    
    func getSeriesByStatus(status: String) async -> [Serie] {
        do {
            return try await serieService.fetchSeries(status: status)
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la récupération des séries par statut")
            return []
        }
    }
}
