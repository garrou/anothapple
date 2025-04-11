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
        isLoading = true
        userStats = await StatsManager.shared.getUserStats()
        isLoading = false
    }
}

// MARK: - StatisticsViewModel mock for preview

extension DashboardViewModel {
    static let mock: DashboardViewModel = .init(router: DashboardRouter.mock)
}
