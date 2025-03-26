//
//  HomePageViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    
    private let router: HomeRouter
    
    init(router: HomeRouter) {
        self.router = router
    }
    
    func getSeriesTabView() -> AnyView {
        router.getSeriesTabView()
    }
    
    func getDisordersTabView() -> AnyView {
        router.getDiscoverTabView()
    }
}

// MARK: - HomePageViewModel mock for preview

extension HomeViewModel {
    static let mock: HomeViewModel = .init(router: HomeRouter.mock)
}
