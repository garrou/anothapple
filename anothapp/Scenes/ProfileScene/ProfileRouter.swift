//
//  ProfileRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 21/04/2025.
//

import SwiftUI

class ProfileRouter {
    
    private let rootCoordinator: NavigationCoordinator
    
    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
}

// MARK: ViewFactory implementation

extension ProfileRouter: Routable {
    
    func makeView() -> AnyView {
        let viewModel = ProfileViewModel(router: self)
        let view = ProfileView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: Hashable implementation

extension ProfileRouter {
    
    func hash(into hasher: inout Hasher) {
    }
    
    static func == (lhs: ProfileRouter, rhs: ProfileRouter) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

extension ProfileRouter {
    static let mock: ProfileRouter = .init(rootCoordinator: AppRouter())
}
