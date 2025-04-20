//
//  SeriesPageViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import Foundation

class DiscoverViewModel: ObservableObject {
    
    @Published var series: [ApiSeriePreview] = []
    @Published var isLoading = false
    @Published var titleSearch = ""
    
    private let router: DiscoverRouter
    private let searchService = SearchService()
    
    init(router: DiscoverRouter) {
        self.router = router
    }
    
    func routeToDiscoverDetail(id: Int) async {
        if let serie = await ApiSeriesCacheManager.shared.getSerie(id: id) {
            router.routeToDiscoverDetail(serie: serie)
        }
    }
    
    @MainActor
    func loadSeries() async {
        isLoading = true
        series = titleSearch.isEmpty
        ? (await ApiSeriesCacheManager.shared.getSeries()).map { ApiSeriePreview(id: $0.id, title: $0.title, poster: $0.poster) }
        : await SearchManager.shared.getSeriesByFilter(title: titleSearch)
        isLoading = false
    }
}

// MARK: - DiscoverViewModel mock for preview

extension DiscoverViewModel {
    static let mock: DiscoverViewModel = .init(router: DiscoverRouter.mock)
}
