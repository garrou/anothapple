//
//  DashboardManager.swift
//  anothapp
//
//  Created by Adrien Garrouste on 11/04/2025.
//

import Foundation

class StatsManager {
    
    static let shared = StatsManager()
    private let statService = StatService()
    
    func getUserStats() async -> UserStat? {
        do {
            return try await statService.getUserStats()
        } catch {
            ToastManager.shared.setToast(message: "Impossible de récupérer les statistiques")
            return nil
        }
    }
}
