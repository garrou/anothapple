//
//  WelcomePageViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 20/03/2025.
//

import Foundation

class WelcomeViewModel: ObservableObject {
    
    @Published var images: [String] = []
    
    private let router: WelcomeRouter
    
    init(router: WelcomeRouter) {
        self.router = router
    }
    
    func navigateToLoginPage() {
        router.routeToLoginPage()
    }
    
    @MainActor
    func loadImages(limit: Int) async {
        images = await SearchManager.shared.getImages(limit: limit)
    }
}

// MARK: - WelcomePageViewModel mock for preview

extension WelcomeViewModel {
    static let mock: WelcomeViewModel = .init(router: WelcomeRouter.mock)
}
