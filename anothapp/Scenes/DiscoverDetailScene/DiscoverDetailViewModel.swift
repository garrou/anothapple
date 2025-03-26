//
//  SeriesPageViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import Foundation

class DiscoverDetailViewModel: ObservableObject {
    
    @Published var serie: ApiSerie
    
    private let router: DiscoverDetailRouter
    
    init(router: DiscoverDetailRouter, serie: ApiSerie) {
        self.router = router
        self.serie = serie
    }
}

// MARK: - DiscoverViewModel mock for preview

extension DiscoverDetailViewModel {
    static let mock: DiscoverDetailViewModel = .init(router: DiscoverDetailRouter.mock, serie: Datasource.mockDiscoverSerie)
}
