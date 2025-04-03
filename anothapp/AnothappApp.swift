//
//  anothappApp.swift
//  anothapp
//
//  Created by Adrien Garrouste on 20/03/2025.
//

import SwiftUI

@main
struct AnothappApp: App {
    
    @StateObject private var toastManager = ToastManager.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationView(appRouter: .init())
                .tint(.secondary)
                .toast(message: toastManager.message, isShowing: $toastManager.showToast, isError: toastManager.isError)
        }
    }
}
