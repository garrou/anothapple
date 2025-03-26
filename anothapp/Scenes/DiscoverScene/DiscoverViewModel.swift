//
//  SeriesPageViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import Foundation

class DiscoverViewModel: ObservableObject {
    
    @Published var series: [Serie] = []
    
    private let router: DiscoverRouter
    
    init(router: DiscoverRouter) {
        self.router = router
    }
}

// MARK: - DiscoverViewModel mock for preview

extension DiscoverViewModel {
    static let mock: DiscoverViewModel = .init(router: DiscoverRouter.mock)
}
