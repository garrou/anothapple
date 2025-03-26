//
//  SerieDetailViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 25/03/2025.
//

import Foundation

class SerieDetailViewModel: ObservableObject {
    
    private let router: SerieDetailRouter
    
    @Published var serie: Serie
    
    init(router: SerieDetailRouter, serie: Serie) {
        self.router = router
        self.serie = serie
    }
}

// MARK: - SerieDetailViewModel mock for preview

extension SerieDetailViewModel {
    static let mock: SerieDetailViewModel = .init(router: SerieDetailRouter.mock, serie: Datasource.mockSerie)
}
