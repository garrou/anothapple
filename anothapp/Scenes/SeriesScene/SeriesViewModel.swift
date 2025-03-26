//
//  SeriesPageViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import Foundation

class SeriesViewModel: ObservableObject {
    
    @Published var series: [Serie] = []
    
    private let router: SeriesRouter
    private let seriesService = SerieService()
    
    init(router: SeriesRouter) {
        self.router = router
    }
    
    func routeToSerieDetail(_ serie: Serie) {
        router.routeToSerieDetail(serie: serie)
    }
    
    @MainActor
    func loadSeries() async {
        do {
            series = try await seriesService.fetchSeries()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

// MARK: - SeriesPageViewModel mock for preview

extension SeriesViewModel {
    static let mock: SeriesViewModel = .init(router: SeriesRouter.mock)
}
