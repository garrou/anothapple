//
//  StatisticsViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 11/04/2025.
//

import Foundation

class DashboardViewModel: ObservableObject {
    
    private let router: DashboardRouter
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
    
    init(router: DashboardRouter) {
        self.router = router
    }
    
    @MainActor
    func loadStats() async {
        if userStats != nil { return }
        isLoading = true
        userStats = await StatsManager.shared.getUserStats()
        seasonsMonthsCurrentYear = await StatsManager.shared.getSeasonsMonthCurrentYear()
        epiodesMonthsCurrentYear = await StatsManager.shared.getEpisodesMonthCurrentYear()
        hoursPerYear = await StatsManager.shared.getHoursPerYear()
        seasonsPerYears = await StatsManager.shared.getSeasonsPerYears()
        episodesPerYears = await StatsManager.shared.getEpisodesPerYears()
        seasonsByMonths = await StatsManager.shared.getSeasonsByMonths()
        monthsRankingHours = await StatsManager.shared.getMonthsRanking()
        timeConsumingSeries = await StatsManager.shared.getTimeConsumingSeries()
        mostViewedKinds = await StatsManager.shared.getMostViewedKinds()
        seasonsByPlatforms = await StatsManager.shared.getSeasonsPlatforms();
        seriesCountries = await StatsManager.shared.getSeriesCountries();
        isLoading = false
    }
}

// MARK: - StatisticsViewModel mock for preview

extension DashboardViewModel {
    static let mock: DashboardViewModel = .init(router: DashboardRouter.mock)
}
