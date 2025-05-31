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
    @Published var openSheet: ProfileEnum? = nil
    @Published var isSheetOpened: Bool = false
    
    init(router: ProfileRouter) {
        self.router = router
    }
    
    func openSheet(_ sheet: ProfileEnum) {
        openSheet = sheet
        isSheetOpened = true
    }
    
    func closeSheet() {
        isSheetOpened = false
        openSheet = nil
    }
    
    func loadProfile() {
        if let user = SecurityManager.shared.getUser() {
            profile = user
        }
    }
}
