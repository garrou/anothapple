//
//  ProfileViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 21/04/2025.
//

import Foundation

class ProfileViewModel: ObservableObject {
    
    private let router: ProfileRouter
    @Published var profile: User? = nil
    
    init(router: ProfileRouter) {
        self.router = router
    }
    
    func loadProfile() {
        if let user = SecurityManager.shared.getUser() {
            profile = user
        }
    }
}
