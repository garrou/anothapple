//
//  SeriesPageViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import Foundation

class SeriesViewModel: ObservableObject {
    
    @Published var series: [Serie] = []
    @Published var titleSearch = ""
    @Published var isLoading = false
    @Published var isFiltersOpened = false
    @Published var selectedFilterTab: FilterTab = .kinds
    @Published var countries: [String] = []
    @Published var kinds: [Kind] = []
    
    @Published var selectedCountries: Set<String> = []
    @Published var selectedKinds: Set<Kind> = []
    
    private let router: SeriesRouter
    
    init(router: SeriesRouter) {
        self.router = router
    }
    
    func routeToSerieDetail(serie: Serie) {
        router.routeToSerieDetail(serie: serie)
    }
    
    @MainActor
    func loadSeries() async {
        isLoading = true
        series = await SeriesCacheManager.shared.getSeries(title: titleSearch, countries: Array(selectedCountries), kinds: Array(selectedKinds))
        isLoading = false
    }
    
    func loadCountries() {
        countries = SeriesCacheManager.shared.getCountries()
    }
    
    @MainActor
    func loadKinds() async {
        kinds = await KindsCacheManager.shared.getKinds()
    }
    
    func selectCountry(_ country: String) async {
        if selectedCountries.contains(country) {
            selectedCountries.remove(country)
        } else {
            selectedCountries.insert(country)
        }
        await loadSeries()
    }
    
    func selectKind(_ kind: Kind) async {
        if selectedKinds.contains(kind) {
            selectedKinds.remove(kind)
        } else {
            selectedKinds.insert(kind)
        }
        await loadSeries()
    }
    
    func isCountrySelected(_ country: String) -> Bool {
        selectedCountries.contains(country)
    }
    
    func isKindSelected(_ kind: Kind) -> Bool {
        selectedKinds.contains(kind)
    }
}

// MARK: - SeriesViewModel mock for preview

extension SeriesViewModel {
    static let mock: SeriesViewModel = .init(router: SeriesRouter.mock)
}
