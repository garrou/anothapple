//
//  TimelineViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 04/04/2025.
//

import Foundation

class TimelineViewModel: ObservableObject {
    
    private let router: TimelineRouter
    @Published var seasons: [Timeline] = []
    @Published var month: Int = 1
    
    init(router: TimelineRouter) {
        self.router = router
    }
    
    func routeToSerieDetails(id: Int) {
        if let serie = SeriesCacheManager.shared.getById(id: id) {
            router.routeToSerieDetails(serie: serie)
        }
    }
    
    @MainActor
    func loadTimeline() async {
        seasons = await SeasonsManager.shared.getSeasonsMonthAgo(month: month)
    }
}

// MARK: - TimelineViewModel mock for preview

extension TimelineViewModel {
    static let mock: TimelineViewModel = .init(router: TimelineRouter.mock)
}
