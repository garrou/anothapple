//
//  StatisticsViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 11/04/2025.
//

import Foundation

class DashboardViewModel: ObservableObject {
    
    private let router: DashboardRouter
    private let userId: String?
    
    @Published var isLoading = false
    @Published var userStats: UserStat? = nil
    @Published var seasonsMonthsCurrentYear: [Stat] = []
    @Published var epiodesMonthsCurrentYear: [Stat] = []
    @Published var hoursPerYear: [Stat] = []
    @Published var seasonsPerYears: [Stat] = []
    @Published var episodesPerYears: [Stat] = []
    @Published var seasonsByMonths: [Stat] = []
    @Published var monthsRankingHours: [Stat] = []
    @Published var timeConsumingSeries: [Stat] = []
    @Published var mostViewedKinds: [Stat] = []
    @Published var seasonsByPlatforms: [Stat] = []
    @Published var seriesCountries: [Stat] = []
    
    var monthTime: String {
        Helper.shared.formatMins(userStats?.monthTime ?? 0)
    }
    
    var totalTime: String {
        Helper.shared.formatMins(userStats?.totalTime ?? 0)
    }
    
    var bestTime: String {
        Helper.shared.formatMins(userStats?.bestMonth?.value ?? 0)
    }
    
    init(router: DashboardRouter, userId: String? = nil) {
        self.router = router
        self.userId = userId
    }
    
    @MainActor
    func loadStats() async {
        if userStats != nil { return }
        isLoading = true
        userStats = await StatsManager.shared.getUserStats(userId: userId)
        seasonsMonthsCurrentYear = await StatsManager.shared.getSeasonsMonthCurrentYear(userId: userId)
        epiodesMonthsCurrentYear = await StatsManager.shared.getEpisodesMonthCurrentYear(userId: userId)
        hoursPerYear = await StatsManager.shared.getHoursPerYear(userId: userId)
        seasonsPerYears = await StatsManager.shared.getSeasonsPerYears(userId: userId)
        episodesPerYears = await StatsManager.shared.getEpisodesPerYears(userId: userId)
        seasonsByMonths = await StatsManager.shared.getSeasonsByMonths(userId: userId)
        monthsRankingHours = await StatsManager.shared.getMonthsRanking(userId: userId)
        timeConsumingSeries = await StatsManager.shared.getTimeConsumingSeries(userId: userId)
        mostViewedKinds = await StatsManager.shared.getMostViewedKinds(userId: userId)
        seasonsByPlatforms = await StatsManager.shared.getSeasonsPlatforms(userId: userId);
        seriesCountries = await StatsManager.shared.getSeriesCountries(userId: userId);
        isLoading = false
    }
}

// MARK: - StatisticsViewModel mock for preview

extension DashboardViewModel {
    static let mock: DashboardViewModel = .init(router: DashboardRouter.mock)
}
