//
//  WelcomePageViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 20/03/2025.
//

import Foundation

class WelcomePageViewModel: ObservableObject {
    
    @Published var images: [String] = []
    
    private let router: WelcomePageRouter
    private let searchService = SearchService()
    
    init(router: WelcomePageRouter) {
        self.router = router
    }
    
    func navigateToLoginPage() {
        router.routeToLoginPage()
    }
    
    func loadImages(limit: Int) async {
        do {
            images = try await searchService.fetchImages(limit: limit)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

// MARK: - WelcomePageViewModel mock for preview

extension WelcomePageViewModel {
    static let mock: WelcomePageViewModel = .init(router: WelcomePageRouter.mock)
}
