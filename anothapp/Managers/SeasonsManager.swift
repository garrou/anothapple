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
}
