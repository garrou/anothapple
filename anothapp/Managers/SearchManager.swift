//
//  SearchManager.swift
//  anothapp
//
//  Created by Adrien Garrouste on 03/04/2025.
//

import Foundation

class SearchManager {

    static let shared = SearchManager()
    private let searchService = SearchService()

    func getEpisodesBySerieBySeason(id: Int, season: Int) async -> [Episode] {
        do {
            return try await searchService.fetchEpisodesBySerieIdBySeason(id: id, num: season)
        } catch {
            ToastManager.shared.setToast(message: "Erreur lors du chargement des épisodes")
            return []
        }
    }
    
    func getSeasonsBySerie(id: Int) async -> [Season] {
        do {
            return try await searchService.fetchSeasonsBySerieId(id: id)
        } catch {
            ToastManager.shared.setToast(message: "Erreur lors du chargement des saisons")
            return []
        }
    }
    
    func getImages(limit: Int) async -> [String] {
        do {
            return try await searchService.fetchImages(limit: limit)
        } catch {
            ToastManager.shared.setToast(message: "Erreur lors du chargement des images")
            return []
        }
    }
    
    func getSimilars(id: Int) async -> [BaseSerie] {
        do {
            return try await searchService.fetchSimilars(id: id)
        } catch {
            ToastManager.shared.setToast(message: "Erreur lors du chargement des séries similaires")
            return []
        }
    }
    
    func getSerieImages(id: Int) async -> [String] {
        do {
            return try await searchService.fetchImages(id: id)
        } catch {
            ToastManager.shared.setToast(message: "Erreur lors du chargement des images de la série")
            return []
        }
    }
    
    func getCharacters(id: Int) async -> [Person] {
        do {
            return try await searchService.fetchCharacters(id: id)
        } catch {
            ToastManager.shared.setToast(message: "Erreur lors du chargement des acteurs de la série")
            return []
        }
    }
}
