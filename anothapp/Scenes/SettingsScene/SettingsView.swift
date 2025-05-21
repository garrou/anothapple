//
//  SettingsRouter.swift
//  anothapp
//
//  Created by Adrien Garrouste on 21/05/2025.
//


import SwiftUI

struct SettingsView: View {
    
    @StateObject var viewModel: SettingsViewModel
    
    var body: some View {
        List {
            Button(action: { viewModel.clearCaches() }) {
                HStack {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                    
                    Text("Vider les caches")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding()
                }
            }
        }
        .navigationTitle("Paramètres")
    }
}
