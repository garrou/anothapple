//
//  ListViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 28/03/2025.
//

import Foundation

class SeriesStatusViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var series: [Serie]
    
    private let router: SeriesStatusRouter
    
    init(router: SeriesStatusRouter) {
        self.router = router
        self.series = router.series
    }
    
    func routeToSerieDetail(serie: Serie) {
        router.routeToSerieDetail(serie: serie)
    }
}

// MARK: - SeriesStatusViewModel mock for preview

extension SeriesStatusViewModel {
    static let mock: SeriesStatusViewModel = .init(router: SeriesStatusRouter.mock)
}
