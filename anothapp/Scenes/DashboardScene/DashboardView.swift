//
//  StatisticView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 11/04/2025.
//

import Charts
import SwiftUI

struct DashboardView: View {
    
    @StateObject var viewModel: DashboardViewModel
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                LoadingView()
            } else {
                GloablStatisticView(viewModel: viewModel)
                BarChart(title: "Saisons par mois cette année", xLabel: "Mois", yLabel: "Saisons", data: viewModel.seasonsMonthsCurrentYear)
                BarChart(title: "Episodes par mois cette année", xLabel: "Mois", yLabel: "Episodes", data: viewModel.epiodesMonthsCurrentYear)
                LineChart(title: "Temps en heures par années", xLabel: "Années", yLabel: "Heures", data: viewModel.hoursPerYear)
                BarChart(title: "Saisons par années", xLabel: "Années", yLabel: "Saisons", data: viewModel.seasonsPerYears)
                BarChart(title: "Episodes par années", xLabel: "Années", yLabel: "Episodes", data: viewModel.episodesPerYears)
                BarChart(title: "Saisons par mois", xLabel: "Mois", yLabel: "Saisons", data: viewModel.seasonsByMonths)
                BarChart(title: "Mois record en heures", xLabel: "Mois", yLabel: "Heures", data: viewModel.monthsRankingHours)
                PieChart(title: "Série les plus chronophages", data: viewModel.timeConsumingSeries)
                PieChart(title: "Genre les plus regardés", data: viewModel.mostViewedKinds)
                PieChart(title: "Saisons par plateformes", data: viewModel.seasonsByPlatforms)
                PieChart(title: "Pays des séries", data: viewModel.seriesCountries)
            }
        }
        .task {
            await viewModel.loadStats()
        }
    }
}

struct GloablStatisticView: View {
    
    @StateObject var viewModel: DashboardViewModel
    
    var body: some View {
        if let userStats = viewModel.userStats {
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
}

struct BarChart: View {
    
    let title: String
    let xLabel: String
    let yLabel: String
    let data: [Stat]
    
    var body: some View {
        VStack {
            Text(title)
            
            Chart(data) { item in
                BarMark(
                    x: .value(xLabel, item.label),
                    y: .value(yLabel, item.value)
                )
                .foregroundStyle(.primary)
            }
            .frame(height: 300)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)).shadow(radius: 4))
        .padding()
        
    }
}

struct LineChart: View {
    
    let title: String
    let xLabel: String
    let yLabel: String
    let data: [Stat]
    
    var body: some View {
        VStack {
            Text(title)
            
            Chart(data) { item in
                LineMark(
                    x: .value(xLabel, item.label),
                    y: .value(yLabel, item.value)
                )
                .foregroundStyle(.primary)
            }
            .frame(height: 300)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)).shadow(radius: 4))
        .padding()
        
    }
}

struct PieChart: View {
    
    let title: String
    let data: [Stat]
    
    var body: some View {
        VStack {
            Text(title)
            
            Chart(data) { item in
                SectorMark(
                    angle: .value("Valeur", item.value)
                )
                .foregroundStyle(by: .value("Label", item.label))
                .foregroundStyle(.primary)
            }
            .chartLegend(position: .bottom, alignment: .center)
            .frame(height: 300)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)).shadow(radius: 4))
        .padding()
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
