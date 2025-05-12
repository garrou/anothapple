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
    @Published var platforms: [Platform] = []
    @Published var showDeleteModal = false
    
    private let router: SeasonDetailsRouter
    
    var viewingTime: String {
        let mins = seasons.count * router.season.episodes * router.serie.duration
        return Helper.shared.formatMins(mins)
    }
    
    init(router: SeasonDetailsRouter) {
        self.router = router
    }
    
    private func updateSeason(seasonId: Int, platformId: Int) {
        let seasonIndex = seasons.firstIndex(where: { $0.id == seasonId })
        if seasonIndex == nil { return }
        let platformIndex = platforms.firstIndex(where: { $0.id == platformId })
        if platformIndex == nil { return }
        let platform = Platform(id: platformId, name: platforms[platformIndex!].name, logo: platforms[platformIndex!].logo)
        let updated = SeasonInfos(id: seasonId, addedAt: seasons[seasonIndex!].addedAt, platform: platform)
        seasons[seasonIndex!] = updated
    }
    
    @MainActor
    func updateSeasonPlatform(seasonId: Int, platformId: Int) async {
        let updated = await SeasonsManager.shared.updateSeason(id: seasonId, platformId: platformId)
        if !updated { return }
        updateSeason(seasonId: seasonId, platformId: platformId)
    }
    
    @MainActor
    func loadSeasonDetails() async {
        isLoading = true
        seasons = await SeriesManager.shared.getSeasonDetails(id: router.serie.id, num: router.season.number)
        platforms = await PlatformsCacheManager.shared.getPlatforms()
        isLoading = false
    }
    
    func deleteSeason(id: Int) async {
        let deleted = await SeasonsManager.shared.deleteSeason(id: id)
        if deleted {
            router.goBack()
        }
    }
}

// MARK: - SeasonDetailsViewModel mock for preview

extension SeasonDetailsViewModel {
    static let mock: SeasonDetailsViewModel = .init(router: SeasonDetailsRouter.mock)
}
