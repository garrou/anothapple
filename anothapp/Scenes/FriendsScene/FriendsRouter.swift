//
//  FriendsRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 23/05/2025.
//

import Foundation
import SwiftUI

class FriendsRouter {
    
    private let rootCoordinator: NavigationCoordinator
    
    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
}

// MARK: ViewFactory implementation

extension FriendsRouter: Routable {
    
    func makeView() -> AnyView {
        let viewModel = FriendsViewModel(router: self)
        let view = FriendsView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: Hashable implementation

extension FriendsRouter {
    
    func hash(into hasher: inout Hasher) {
    }
    
    static func == (lhs: FriendsRouter, rhs: FriendsRouter) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

extension FriendsRouter {
    static let mock: FriendsRouter = .init(rootCoordinator: AppRouter())
}
