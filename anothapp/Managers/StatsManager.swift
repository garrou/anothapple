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
    
    func getUserStats(userId: String?) async -> UserStat? {
        do {
            return try await statService.getUserStats(userId: userId)
        } catch {
            ToastManager.shared.setToast(message: "Impossible de récupérer les statistiques")
            return nil
        }
    }
    
    func getSeasonsMonthCurrentYear(userId: String?) async -> [Stat] {
        do {
            return try await statService.getGroupedCountByTypeByPeriod(type: .seasons, period: .year, userId: userId)
        } catch {
            ToastManager.shared.setToast(message: "Impossible de récupérer les statistiques des saisons de l'année")
            return []
        }
    }
    
    func getEpisodesMonthCurrentYear(userId: String?) async -> [Stat] {
        do {
            return try await statService.getGroupedCountByTypeByPeriod(type: .episodes, period: .year, userId: userId)
        } catch {
            ToastManager.shared.setToast(message: "Impossible de récupérer les statistiques des épisodes de l'année")
            return []
        }
    }
    
    func getHoursPerYear(userId: String?) async -> [Stat] {
        do {
            return try await statService.getTimeByType(type: .years, userId: userId)
        } catch {
            ToastManager.shared.setToast(message: "Impossible de récupérer les statistiques des heures par années")
            return []
        }
    }
    
    func getSeasonsPerYears(userId: String?) async -> [Stat] {
        do {
            return try await statService.getGroupedCountByTypeByPeriod(type: .seasons, period: .years, userId: userId)
        } catch {
            ToastManager.shared.setToast(message: "Impossible de récupérer les statistiques des seasons par années")
            return []
        }
    }
    
    func getEpisodesPerYears(userId: String?) async -> [Stat] {
        do {
            return try await statService.getGroupedCountByTypeByPeriod(type: .episodes, period: .years, userId: userId)
        } catch {
            ToastManager.shared.setToast(message: "Impossible de récupérer les statistiques des épisodes par années")
            return []
        }
    }
    
    func getSeasonsByMonths(userId: String?) async -> [Stat] {
        do {
            return try await statService.getGroupedCountByTypeByPeriod(type: .seasons, period: .months, userId: userId)
        } catch {
            ToastManager.shared.setToast(message: "Impossible de récupérer les statistiques des seasons par mois")
            return []
        }
    }
    
    func getMonthsRanking(userId: String?) async -> [Stat] {
        do {
            return try await statService.getGroupedCountByTypeByPeriod(type: .bestMonths, userId: userId)
        } catch {
            ToastManager.shared.setToast(message: "Impossible de récupérer les statistiques des épisodes par mois")
            return []
        }
    }
    
    func getTimeConsumingSeries(userId: String?) async -> [Stat] {
        do {
            return try await statService.getTimeByType(type: .rank, userId: userId)
        } catch {
            ToastManager.shared.setToast(message: "Impossible de récupérer les statistiques des séries chronophages")
            return []
        }
    }
    
    func getMostViewedKinds(userId: String?) async -> [Stat] {
        do {
            return try await statService.getGroupedCountByTypeByPeriod(type: .kinds, userId: userId)
        } catch {
            ToastManager.shared.setToast(message: "Impossible de récupérer les statistiques des genres de séries")
            return []
        }
    }
    
    func getSeasonsPlatforms(userId: String?) async -> [Stat] {
        do {
            return try await statService.getGroupedCountByTypeByPeriod(type: .platforms, userId: userId)
        } catch {
            ToastManager.shared.setToast(message: "Impossible de récupérer les statistiques des plateformes")
            return []
        }
    }
    
    func getSeriesCountries(userId: String?) async -> [Stat] {
        do {
            return try await statService.getGroupedCountByTypeByPeriod(type: .countries, userId: userId)
        } catch {
            ToastManager.shared.setToast(message: "Impossible de récupérer les statistiques des pays de production")
            return []
        }
    }
}
