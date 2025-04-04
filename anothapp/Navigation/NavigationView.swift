//
//  NavigationView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 20/03/2025.
//

import SwiftUI

struct NavigationView: View {
    
    @StateObject var appRouter: AppRouter
    @StateObject private var toastManager = ToastManager.shared
    
    var body: some View {
        NavigationStack(path: $appRouter.paths) {
            appRouter.resolveInitialRouter()
                .makeView()
                .navigationDestination(for: AnyRoutable.self) { router in
                    router.makeView()
                }
        }
        .tint(.secondary)
        .toast(message: toastManager.message, isShowing: $toastManager.showToast, isError: toastManager.isError)
    }
}
