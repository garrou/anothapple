//
//  anothappApp.swift
//  anothapp
//
//  Created by Adrien Garrouste on 20/03/2025.
//

import SwiftUI

@main
struct AnothappApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView(appRouter: .init()).tint(.secondary)
        }
    }
}
