//
//  SeriesPageViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import Foundation

class SeriesViewModel: ObservableObject {
    
    @Published var series: [Serie] = []
    @Published var titleSearch: String = ""
    
    private let router: SeriesRouter
    private let seriesService = SerieService()
    
    init(router: SeriesRouter) {
        self.router = router
    }
    
    func routeToSerieDetail(serie: Serie) {
        router.routeToSerieDetail(serie: serie)
    }
    
    @MainActor
    func loadSeries() async {
        series = await SeriesCacheManager.shared.getSeries(title: titleSearch)
    }
}

// MARK: - SeriesPageViewModel mock for preview

extension SeriesViewModel {
    static let mock: SeriesViewModel = .init(router: SeriesRouter.mock)
}
