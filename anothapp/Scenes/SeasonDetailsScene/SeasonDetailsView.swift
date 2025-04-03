//
//  SeasonDetailsView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 03/04/2025.
//

import SwiftUI

struct SeasonDetailsView: View {
    
    @StateObject var viewModel: SeasonDetailsViewModel
    
    var body: some View {
        ScrollView {
            GridView(items: viewModel.seasons, columns: 2) { season in
                VStack {
                    if season.platform.logo.isEmpty {
                        Text(season.platform.name)
                    } else {
                        ImageCardView(url: season.platform.logo)
                    }
                    Text("\(formattedDate(season.addedAt))")
                }
                
            }
        }
        .padding(.vertical, 10)
        .navigationTitle("\(viewModel.seasons.count) visionnage(s)")
        .onAppear {
            Task {
                await viewModel.loadSeasonDetails()
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    SeasonDetailsView(viewModel: .mock)
}
