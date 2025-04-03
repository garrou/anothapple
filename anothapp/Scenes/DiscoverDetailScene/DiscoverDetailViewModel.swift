//
//  SeriesPageViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import Foundation

class DiscoverDetailViewModel: ObservableObject {
    
    @Published var serie: ApiSerie
    @Published var isMenuOpened = false
    @Published var isSerieAdded = false
    @Published var isSerieInList = false
    @Published var showToast = false
    @Published var message = ""
    @Published var isError = false
    
    private let router: DiscoverDetailRouter
    
    init(router: DiscoverDetailRouter, serie: ApiSerie) {
        self.router = router
        self.serie = serie
        self.isSerieAdded = checkIfAlreadyAdded()
        self.isSerieInList = checkIfAlreadyInList()
    }
    
    func checkIfAlreadyAdded() -> Bool {
        SeriesCacheManager.shared.getSerie(id: serie.id) != nil
    }
    
    func checkIfAlreadyInList() -> Bool {
        SeriesListCacheManager.shared.getSerie(id: serie.id) != nil
    }
    
    @MainActor
    func addSerie() async {
        isSerieAdded = await SeriesCacheManager.shared.addSerie(id: serie.id)
        message = isSerieAdded ? "\(serie.title) ajoutée" : "Impossible d'ajouter la série"
        isError = !isSerieAdded
        showToast = true
    }
    
    @MainActor
    func changeInList() async {
        let changed = isSerieInList
            ? await SeriesListCacheManager.shared.deleteSerie(id: serie.id)
            : await SeriesListCacheManager.shared.addSerie(id: serie.id)
        
        if changed {
            isSerieInList.toggle()
            message = isSerieInList ? "\(serie.title) ajoutée dans la liste" : "\(serie.title) supprimée de la liste"
        } else {
            message = "Erreur durant l'ajout"
        }
        isError = !changed
        showToast = true
    }
}

// MARK: - DiscoverViewModel mock for preview

extension DiscoverDetailViewModel {
    static let mock: DiscoverDetailViewModel = .init(router: DiscoverDetailRouter.mock, serie: Datasource.mockDiscoverSerie)
}
