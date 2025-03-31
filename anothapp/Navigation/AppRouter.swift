//
//  AppRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 20/03/2025.
//

import SwiftUI

class AppRouter: ObservableObject {
    
    @Published var paths: NavigationPath

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
            self.paths.append(AnyRoutable(router))
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
