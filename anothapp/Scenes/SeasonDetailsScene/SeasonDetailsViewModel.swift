//
//  SeasonDetailsViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 03/04/2025.
//

import Foundation
import SwiftUI

class SeasonDetailsViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var seasons: [SeasonInfos] = []
    @Published var platforms: [Platform] = []
    @Published var showDeleteModal = false
    @Published var seasonsAddedAt: [Int:Date] = [:]
    @Published var seasonsPlatformId: [Int:Int] = [:]
    
    private let router: SeasonDetailsRouter
    
    var viewingTime: String {
        let mins = seasons.count * router.season.episodes * router.serie.duration
        return Helper.shared.formatMins(mins)
    }
    
    init(router: SeasonDetailsRouter) {
        self.router = router
    }
    
    private func changeSeason(seasonId: Int, platformId: Int, addedAt: Date) {
        let seasonIndex = seasons.firstIndex(where: { $0.id == seasonId })
        if seasonIndex == nil { return }
        
        let platformIndex = platforms.firstIndex(where: { $0.id == platformId })
        if platformIndex == nil { return }
        
        let platform = Platform(id: platformId, name: platforms[platformIndex!].name, logo: platforms[platformIndex!].logo)
        let updated = SeasonInfos(id: seasonId, addedAt: addedAt, platform: platform)
        seasons[seasonIndex!] = updated
    }
    
    func bindingForDate(_ key: Int) -> Binding<Date> {
        Binding<Date>(
            get: {
                self.seasonsAddedAt[key] ?? Date()
            },
            set: { newValue in
                self.seasonsAddedAt[key] = newValue
            }
        )
    }
    
    func selectPlatformId(seasonId: Int, platformId: Int) {
        seasonsPlatformId[seasonId] = platformId
        changeSeason(seasonId: seasonId, platformId: platformId, addedAt: seasonsAddedAt[seasonId]!)
    }
    
    @MainActor
    func updateSeason(seasonId: Int) async {
        let platformId = seasonsPlatformId[seasonId]
        let addedAt = seasonsAddedAt[seasonId]
        let updated = await SeasonsManager.shared.updateSeason(id: seasonId, platformId: platformId, viewedAt: addedAt)
        if !updated { return }
        changeSeason(seasonId: seasonId, platformId: platformId!, addedAt: addedAt!)
    }
    
    @MainActor
    func loadSeasonDetails() async {
        isLoading = true
        seasons = await SeriesManager.shared.getSeasonDetails(id: router.serie.id, num: router.season.number)
        platforms = await PlatformsCacheManager.shared.getPlatforms()
        seasonsAddedAt = seasons.reduce(into: [Int: Date]()) { result, season in
            result[season.id] = season.addedAt
        }
        seasonsPlatformId = seasons.reduce(into: [Int: Int]()) { result, season in
            result[season.id] = season.platform.id
        }
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
