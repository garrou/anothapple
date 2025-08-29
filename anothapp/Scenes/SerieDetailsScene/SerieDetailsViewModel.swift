//
//  SerieDetailViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 25/03/2025.
//

import Foundation
import SwiftUI

class SerieDetailsViewModel: ObservableObject {
    
    private let router: SerieDetailsRouter
    
    @Published var serie: Serie
    @Published var infos: SerieInfos = .init(seasons: [], time: 0, episodes: 0)
    @Published var seasons: [Season] = []
    @Published var viewedByFriends: [Friend] = []
    @Published var selectedTab: SerieDetailsTab = .seasons
    @Published var isMenuOpened = false
    @Published var showDeleteModal = false
    @Published var tabContentHeight: CGFloat = ContentHeightPreferenceKey.defaultValue
    @Published var openFriendDetails = false
    @Published var friendIdToConsult: String? = nil
    @Published var openUpdateSerieModal = false
    @Published var addedAt: Date
    @Published var notes: [Note] = []
    
    init(router: SerieDetailsRouter, serie: Serie) {
        self.router = router
        self.serie = serie
        addedAt = serie.addedAt
    }
    
    func routeToEpisodesView(season: Int) {
        router.routeToEpisodesView(id: serie.id, season: season)
    }
    
    func routeToSeasonDetails(season: Season) {
        router.routeToSeasonDetailsView(serie: serie, season: season)
    }
    
    @MainActor
    func changeNote(_ note: Note) async {
        serie = await SeriesCacheManager.shared.changeNote(serie: serie, note: note)
    }
    
    @MainActor
    func changeFavorite() async {
        serie = await SeriesCacheManager.shared.changeFavorite(serie: serie)
    }
    
    @MainActor
    func changeWatching() async {
        serie = await SeriesCacheManager.shared.changeWatching(serie: serie)
    }
    
    @MainActor
    func changeAddedAt() async {
        serie = await SeriesCacheManager.shared.changeAddedAt(serie: serie, addedAt: addedAt)
        openUpdateSerieModal = false
    }
    
    func deleteSerie() async {
        let deleted = await SeriesCacheManager.shared.deleteSerie(id: serie.id)
        
        if deleted {
            router.routeToHomePage()
        }
    }
    
    func routeToDiscoverDetails() async {
        if let fetched = await ApiSeriesCacheManager.shared.getSerie(id: serie.id) {
            router.routeToDiscoverDetails(serie: fetched)
        }
    }
    
    @MainActor
    func getNotes() async {
        notes = await NotesCacheManager.shared.getNotes()
    }
    
    @MainActor
    func getSerieInfos() async {
        infos = await SeriesManager.shared.getSerieInfos(id: serie.id)
    }
    
    @MainActor
    func getSeasonsToAdd() async {
        if !seasons.isEmpty { return }
        seasons = await SearchManager.shared.getSeasonsBySerie(id: serie.id)
    }
    
    @MainActor
    func getFriendsWhoWatch() async {
        if !viewedByFriends.isEmpty { return }
        viewedByFriends = await FriendsManager.shared.getFriendsWhoWatch(id: serie.id)
    }
    
    func addSeason(season: Season) async {
        _ = await SeriesManager.shared.addSeason(id: serie.id, season: season)
    }
    
    func openFriendDetailsView(userId: String) {
        openFriendDetails = true
        friendIdToConsult = userId
    }
    
    func closeFriendDetails() {
        openFriendDetails = false
        friendIdToConsult = nil
    }
    
    func getDashboardView() -> AnyView {
        if let id = friendIdToConsult {
            return router.getDashboardView(userId: id)
        }
        return AnyView(EmptyView())
    }
}

// MARK: - SerieDetailViewModel mock for preview

extension SerieDetailsViewModel {
    static let mock: SerieDetailsViewModel = .init(router: SerieDetailsRouter.mock, serie: Datasource.mockSerie)
}
