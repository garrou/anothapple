//
//  AppRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 20/03/2025.
//

import SwiftUI

enum AppTab {
    case series
    case discover
}

class AppRouter: ObservableObject {
    
    @Published var paths: NavigationPath
    @Published var selectedTab: AppTab = .series

    init(paths: NavigationPath = NavigationPath()) {
        self.paths = paths
    }
    
    func resolveInitialRouter() -> any Routable {
        isLoggedIn() ? HomeRouter(rootCoordinator: self) : WelcomeRouter(rootCoordinator: self)
    }
    
    private func isLoggedIn() -> Bool {
        SecurityHelper.getUser() != nil
    }
}

extension AppRouter: NavigationCoordinator {
    func push(_ router: any Routable) {
        DispatchQueue.main.async {
            let wrappedRouter = AnyRoutable(router)
            self.paths.append(wrappedRouter)
        }
    }
    
    func popLast() {
        DispatchQueue.main.async {
            self.paths.removeLast()
        }
    }
    
    func popToRoot() {
        DispatchQueue.main.async {
            self.paths.removeLast(self.paths.count)
        }
    }
    
}
