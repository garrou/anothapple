//
//  SeriesPageViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import Foundation

class DiscoverViewModel: ObservableObject {
    
    @Published var series: [ApiSerie] = []
    
    private let router: DiscoverRouter
    private let searchService = SearchService()
    
    init(router: DiscoverRouter) {
        self.router = router
    }
    
    func routeToDiscoverDetail(serie: ApiSerie) {
        router.routeToDiscoverDetail(serie: serie)
    }
    
    @MainActor
    func loadDiscoverSeries(limit: Int) async {
        do {
            series = try await searchService.fetchSuggestions(limit: limit)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

// MARK: - DiscoverViewModel mock for preview

extension DiscoverViewModel {
    static let mock: DiscoverViewModel = .init(router: DiscoverRouter.mock)
}
