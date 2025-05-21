//
//  SettingsRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 21/05/2025.
//

import Foundation

class SettingsViewModel: ObservableObject {
    
    private let router: SettingsRouter
    
    init(router: SettingsRouter) {
        self.router = router
    }
    
    func clearCaches() {
        StateManager.shared.clearCaches()
        ToastManager.shared.setToast(message: "Caches vidés", isError: false)
        router.goBack()
    }
}
