//
//  SeasonDetailsViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 03/04/2025.
//

import Foundation

class SeasonDetailsViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var seasons: [SeasonInfos] = []
    
    private let router: SeasonDetailsRouter
    
    var viewingTime: String {
        let mins = seasons.count * router.season.episodes * router.serie.duration
        return Helper.shared.formatMins(mins)
    }
    
    init(router: SeasonDetailsRouter) {
        self.router = router
    }
    
    @MainActor
    func loadSeasonDetails() async {
        isLoading = true
        seasons = await SeriesManager.shared.getSeasonDetails(id: router.serie.id, num: router.season.number)
        isLoading = false
    }
    
    func getPlatform(id: Int) -> Platform? {
        PlatformsCacheManager.shared.getById(id: id)
    }
}

// MARK: - SeasonDetailsViewModel mock for preview

extension SeasonDetailsViewModel {
    static let mock: SeasonDetailsViewModel = .init(router: SeasonDetailsRouter.mock)
}
