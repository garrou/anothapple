//
//  StatisticsViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 11/04/2025.
//

import Foundation
import SwiftUI

class DashboardViewModel: ObservableObject {
    
    private let router: DashboardRouter
    private let userId: String?
    
    @Published var isLoading = false
    @Published var stats: UserStat? = nil
    @Published var friendSharedSeries: [Serie] = []
    @Published var friendFavoritesSeries: [Serie] = []
    
    var mustShowFriendStats: Bool {
        userId != nil
    }
    
    var friendSharedSeriesLabel: String {
        let num = friendSharedSeries.count
        let middle = Helper.shared.formatPlural(str: "série", num: num, showNum: false)
        let end = Helper.shared.formatPlural(str: "commune", num: num, showNum: false)
        return "\(num) \(middle) \(end)"
    }
    
    var friendFavoriteSeriesLabel: String {
        let num = friendFavoritesSeries.count
        let middle = Helper.shared.formatPlural(str: "série", num: num, showNum: false)
        let end = Helper.shared.formatPlural(str: "favorite", num: num, showNum: false)
        return "\(num) \(middle) \(end)"
    }
    
    var monthTime: String {
        Helper.shared.formatMins(stats?.monthTime ?? 0)
    }
    
    var totalTime: String {
        Helper.shared.formatMins(stats?.totalTime ?? 0)
    }
    
    var bestTime: String {
        Helper.shared.formatMins(stats?.bestMonth?.value ?? 0)
    }
    
    init(router: DashboardRouter, userId: String? = nil) {
        self.router = router
        self.userId = userId
    }
    
    @MainActor
    func loadStats() async {
        if stats != nil { return }
        isLoading = true
        stats = await StatsManager.shared.getUserStats(userId: userId)
        
        if mustShowFriendStats {
            friendSharedSeries = await SeriesManager.shared.getSeriesByStatus(status: .shared, userId: userId!)
            friendFavoritesSeries = await SeriesManager.shared.getSeriesByStatus(status: .favorite, userId: userId!)
        }
        isLoading = false
    }
    
    func routeToDiscoverDetails(id: Int) async {
        if let fetched = await ApiSeriesCacheManager.shared.getSerie(id: id) {
            router.routeToDiscoverDetails(serie: fetched)
        }
    }
}

// MARK: - StatisticsViewModel mock for preview

extension DashboardViewModel {
    static let mock: DashboardViewModel = .init(router: DashboardRouter.mock)
}
