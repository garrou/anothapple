//
//  SettingsRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 21/05/2025.
//

import SwiftUI

class SettingsRouter {
    
    private let rootCoordinator: NavigationCoordinator
    
    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
    
    func goBack() {
        rootCoordinator.popToRoot()
    }
}

// MARK: ViewFactory implementation

extension SettingsRouter: Routable {
    
    func makeView() -> AnyView {
        let viewModel = SettingsViewModel(router: self)
        let view = SettingsView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: Hashable implementation

extension SettingsRouter {
    
    func hash(into hasher: inout Hasher) {
    }
    
    static func == (lhs: SettingsRouter, rhs: SettingsRouter) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

extension SettingsRouter {
    static let mock: SettingsRouter = .init(rootCoordinator: AppRouter())
}
