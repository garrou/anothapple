//
//  SeriesPageViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import Foundation

class DiscoverDetailsViewModel: ObservableObject {
    
    @Published var serie: ApiSerie
    @Published var isMenuOpened = false
    @Published var isSerieAdded = false
    @Published var isSerieInList = false
    
    private let router: DiscoverDetailsRouter
    
    init(router: DiscoverDetailsRouter, serie: ApiSerie) {
        self.router = router
        self.serie = serie
        self.isSerieAdded = checkIfAlreadyAdded()
        self.isSerieInList = checkIfAlreadyInList()
    }
    
    func checkIfAlreadyAdded() -> Bool {
        SeriesCacheManager.shared.getById(id: serie.id) != nil
    }
    
    func checkIfAlreadyInList() -> Bool {
        SeriesListCacheManager.shared.getById(id: serie.id) != nil
    }
    
    @MainActor
    func addSerie() async {
        isSerieAdded = await SeriesCacheManager.shared.addSerie(id: serie.id)
    }
    
    @MainActor
    func changeInList() async {
        let changed = isSerieInList
            ? await SeriesListCacheManager.shared.deleteSerie(id: serie.id)
            : await SeriesListCacheManager.shared.addSerie(id: serie.id)
        
        if changed {
            isSerieInList.toggle()
            ToastManager.shared.setToast(message: isSerieInList ? "\(serie.title) ajoutée dans la liste" : "\(serie.title) supprimée de la liste", isError: !changed)
        }
    }
}

// MARK: - DiscoverDetailsViewModel mock for preview

extension DiscoverDetailsViewModel {
    static let mock: DiscoverDetailsViewModel = .init(router: DiscoverDetailsRouter.mock, serie: Datasource.mockDiscoverSerie)
}
