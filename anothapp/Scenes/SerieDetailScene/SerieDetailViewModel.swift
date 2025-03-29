//
//  SerieDetailViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 25/03/2025.
//

import Foundation

enum SerieDetailTab {
    case seasons
    case add
    case viewedBy
}

class SerieDetailViewModel: ObservableObject {
    
    private let router: SerieDetailRouter
    
    @Published var serie: Serie
    @Published var infos: SerieInfos = .init(seasons: [], time: 0, episodes: 0)
    @Published var selectedTab: SerieDetailTab = .seasons
    @Published var isMenuOpened = false
    @Published var showDeleteModal = false
    
    init(router: SerieDetailRouter, serie: Serie) {
        self.router = router
        self.serie = serie
    }
    
    @MainActor
    func changeFavorite() async {
        serie = await SeriesCacheManager.shared.changeFavorite(serie: serie)
    }
    
    @MainActor
    func changeWatching() async {
        serie = await SeriesCacheManager.shared.changeWatching(serie: serie)
    }
    
    func deleteSerie() async {
        let deleted = await SeriesCacheManager.shared.removeSerie(key: String(serie.id))
        
        if deleted {
            router.routeToHomePage()
        }
    }
    
    func routeToDiscoverDetails() async {
        let fetched = await ApiSeriesCacheManager.shared.getSerie(key: String(serie.id))
        if fetched != nil {
            router.routeToDiscoverDetails(serie: fetched!)
        }
    }
    
    @MainActor
    func getSerieInfos() async {
        infos = await SeriesCacheManager.shared.getSerieInfos(id: serie.id)
    }
}

// MARK: - SerieDetailViewModel mock for preview

extension SerieDetailViewModel {
    static let mock: SerieDetailViewModel = .init(router: SerieDetailRouter.mock, serie: Datasource.mockSerie)
}
