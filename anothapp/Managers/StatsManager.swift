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
    
    func getSeasonsMonthCurrentYear() async -> [Stat] {
        do {
            return try await statService.getGroupedCountByTypeByPeriod(type: .seasons, period: .year)
        } catch {
            ToastManager.shared.setToast(message: "Impossible de récupérer les statistiques des saisons de l'année")
            return []
        }
    }
    
    func getEpisodesMonthCurrentYear() async -> [Stat] {
        do {
            return try await statService.getGroupedCountByTypeByPeriod(type: .episodes, period: .year)
        } catch {
            ToastManager.shared.setToast(message: "Impossible de récupérer les statistiques des épisodes de l'année")
            return []
        }
    }
    
    func getHoursPerYear() async -> [Stat] {
        do {
            return try await statService.getTimeByType(type: .years)
        } catch {
            ToastManager.shared.setToast(message: "Impossible de récupérer les statistiques des heures par années")
            return []
        }
    }
    
    func getSeasonsPerYears() async -> [Stat] {
        do {
            return try await statService.getGroupedCountByTypeByPeriod(type: .seasons, period: .years)
        } catch {
            ToastManager.shared.setToast(message: "Impossible de récupérer les statistiques des seasons par années")
            return []
        }
    }
    
    func getEpisodesPerYears() async -> [Stat] {
        do {
            return try await statService.getGroupedCountByTypeByPeriod(type: .episodes, period: .years)
        } catch {
            ToastManager.shared.setToast(message: "Impossible de récupérer les statistiques des épisodes par années")
            return []
        }
    }
    
    func getSeasonsByMonths() async -> [Stat] {
        do {
            return try await statService.getGroupedCountByTypeByPeriod(type: .seasons, period: .months)
        } catch {
            ToastManager.shared.setToast(message: "Impossible de récupérer les statistiques des seasons par mois")
            return []
        }
    }
    
    func getMonthsRanking() async -> [Stat] {
        do {
            return try await statService.getGroupedCountByTypeByPeriod(type: .bestMonths)
        } catch {
            ToastManager.shared.setToast(message: "Impossible de récupérer les statistiques des épisodes par mois")
            return []
        }
    }
    
    func getTimeConsumingSeries() async -> [Stat] {
        do {
            return try await statService.getTimeByType(type: .rank)
        } catch {
            ToastManager.shared.setToast(message: "Impossible de récupérer les statistiques des séries chronophages")
            return []
        }
    }
    
    func getMostViewedKinds() async -> [Stat] {
        do {
            return try await statService.getGroupedCountByTypeByPeriod(type: .kinds)
        } catch {
            ToastManager.shared.setToast(message: "Impossible de récupérer les statistiques des genres de séries")
            return []
        }
    }
    
    func getSeasonsPlatforms() async -> [Stat] {
        do {
            return try await statService.getGroupedCountByTypeByPeriod(type: .platforms)
        } catch {
            ToastManager.shared.setToast(message: "Impossible de récupérer les statistiques des plateformes")
            return []
        }
    }
    
    func getSeriesCountries() async -> [Stat] {
        do {
            return try await statService.getGroupedCountByTypeByPeriod(type: .countries)
        } catch {
            ToastManager.shared.setToast(message: "Impossible de récupérer les statistiques des pays de production")
            return []
        }
    }
}
