//
//  StatisticView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 11/04/2025.
//

import SwiftUI

struct DashboardView: View {
    
    @StateObject var viewModel: DashboardViewModel
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                LoadingView()
            } else if let userStats = viewModel.userStats {
                VStack(alignment: .leading, spacing: 16) {
                    StatTile(title: "Ce mois", value: "\(viewModel.monthTime)")
                    StatTile(title: "Temps total", value: "\(viewModel.totalTime)")
                    
                    if let best = userStats.bestMonth {
                        StatTile(title: "Meilleur mois (\(best.label))", value: "\(viewModel.bestTime)")
                    }
                    HStack {
                        StatTile(title: "Series", value: "\(userStats.nbSeries)")
                        StatTile(title: "Saisons", value: "\(userStats.nbSeasons)")
                        StatTile(title: "Episodes", value: "\(userStats.nbEpisodes)")
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)).shadow(radius: 4))
                .padding()
            }
        }
        .task {
            await viewModel.loadStats()
        }
    }
}

struct StatTile: View {
    let title: String
    let value: String

    var body: some View {
        VStack {
            Text(value)
                .font(.headline)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct SeasonsMonthsCurrentYear: View {
    
    @StateObject var viewModel: DashboardViewModel
    
    var body: some View {
        
    }
}
