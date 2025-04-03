//
//  NavigationView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 20/03/2025.
//

import SwiftUI

struct NavigationView: View {
    
    @StateObject var appRouter: AppRouter
    
    var body: some View {
        NavigationStack(path: $appRouter.paths) {
            appRouter.resolveInitialRouter()
                .makeView()
                .navigationDestination(for: AnyRoutable.self) { router in
                    router.makeView()
                }
        }.tint(.secondary)
    }
}
