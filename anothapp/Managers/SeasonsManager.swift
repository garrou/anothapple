//
//  SeasonManager.swift
//  anothapp
//
//  Created by Adrien Garrouste on 04/04/2025.
//

import Foundation

class SeasonsManager {
    
    static let shared = SeasonsManager()
    private let seasonService = SeasonService()
    
    func getSeasonsMonthAgo(month: Int) async -> [Timeline] {
        do {
            return try await seasonService.fetchSeasonsMonthAgo(month: month)
        } catch {
            ToastManager.shared.setToast(message: "Erreur lors de la récupération de l'historique pour \(month) mois")
            return []
        }
    }
    
    func updateSeason(id: Int, platformId: Int?, viewedAt: Date?) async -> Bool {
        var updated = false
        do {
            if let platformId = platformId, let viewedAt = viewedAt {
                updated = try await seasonService.updateSeason(request: .init(id: id, platform: platformId, viewedAt: viewedAt))
            }
            ToastManager.shared.setToast(message: updated ? "Saison modifiée" : "Erreur durant la modification", isError: !updated)
        } catch {
            ToastManager.shared.setToast(message: "Erreur lors de la mise à jour")
        }
        return updated
    }
    
    func deleteSeason(id: Int) async -> Bool {
        var deleted = false
        do {
            deleted = try await seasonService.deleteSeason(id: id)
            ToastManager.shared.setToast(message: deleted ? "Saison supprimée" : "Erreur durant la suppression", isError: !deleted)
        } catch {
            ToastManager.shared.setToast(message: "Erreur lors de la suppression de la série")
        }
        return deleted
    }
}
