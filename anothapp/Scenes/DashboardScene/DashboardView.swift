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
                GlobalStatisticView(viewModel: viewModel)
                
                if viewModel.mustShowFriendStats {
                    FriendSeriesView(viewModel: viewModel, series: viewModel.friendSharedSeries, title: viewModel.friendSharedSeriesLabel)
                    FriendSeriesView(viewModel: viewModel, series: viewModel.friendFavoritesSeries, title: viewModel.friendFavoriteSeriesLabel)
                }
                if let userStats = viewModel.stats {
                    BarChart(title: "Saisons par mois cette année", xLabel: "Mois", yLabel: "Saisons", data: userStats.seasonsMonthCurrentYear, color: .green)
                    BarChart(title: "Episodes par mois cette année", xLabel: "Mois", yLabel: "Episodes", data: userStats.episodesMonthCurrentYear, color: .cyan)
                    LineChart(title: "Temps en heures par années", xLabel: "Années", yLabel: "Heures", data: userStats.timeYears, color: .yellow)
                    BarChart(title: "Saisons par années", xLabel: "Années", yLabel: "Saisons", data: userStats.seasonsYears, color: .orange)
                    BarChart(title: "Episodes par années", xLabel: "Années", yLabel: "Episodes", data: userStats.episodesYears, color: .pink)
                    BarChart(title: "Saisons par mois", xLabel: "Mois", yLabel: "Saisons", data: userStats.seasonsMonths, color: .mint)
                    BarChart(title: "Mois record en heures", xLabel: "Mois", yLabel: "Heures", data: userStats.bestMonths, color: .red)
                    PieChart(title: "Série les plus chronophages en heures", data: userStats.seriesRankingTime)
                    PieChart(title: "Genre les plus regardés", data: userStats.seriesKinds)
                    PieChart(title: "Saisons par plateformes", data: userStats.seasonsPlatforms)
                    PieChart(title: "Pays des séries", data: userStats.seriesCountries)
                    PieChart(title: "Notes attribuées aux séries", data: userStats.seriesNotes)
                }
            }
        }
        .task {
            await viewModel.loadStats()
        }
    }
}

private struct FriendSeriesView: View {
    
    @StateObject var viewModel: DashboardViewModel
    let series: [Serie]
    let title: String
    
    var body: some View {
        DisclosureGroup(title) {
            GridView(items: series, columns: 1) { serie in
                Button(action: {
                    Task {
                        await viewModel.routeToDiscoverDetails(id: serie.id)
                    }
                })
                {
                    HStack {
                        Text(serie.title)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .border(Color(.separator), width: 0.5)
                }
            }.padding(.top, 5)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)).shadow(radius: 4))
        .padding(.horizontal, 16)
    }
}

private struct GlobalStatisticView: View {
    
    @StateObject var viewModel: DashboardViewModel
    
    var body: some View {
        if let userStats = viewModel.stats {
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

private struct BarChart: View {
    
    let title: String
    let xLabel: String
    let yLabel: String
    let data: [Stat]
    let color: Color
    
    var body: some View {
        if data.isEmpty {
            EmptyView()
        } else {
            VStack {
                Text(title)
                
                Chart(data) { item in
                    BarMark(
                        x: .value(xLabel, item.label),
                        y: .value(yLabel, item.value)
                    )
                    .foregroundStyle(color)
                }
                .frame(height: 300)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)).shadow(radius: 4))
            .padding()
        }
        
    }
}

private struct LineChart: View {
    
    let title: String
    let xLabel: String
    let yLabel: String
    let data: [Stat]
    let color: Color
    
    var body: some View {
        if data.isEmpty {
            EmptyView()
        } else {
            VStack {
                Text(title)
                
                Chart(data) { item in
                    LineMark(
                        x: .value(xLabel, item.label),
                        y: .value(yLabel, item.value)
                    )
                    .foregroundStyle(color)
                }
                .frame(height: 300)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)).shadow(radius: 4))
            .padding()
        }
        
    }
}

private struct PieChart: View {
    
    let title: String
    let data: [Stat]
    
    var body: some View {
        if data.isEmpty {
            EmptyView()
        } else {
            VStack {
                Text(title)
                
                Chart(data) { item in
                    SectorMark(
                        angle: .value("Valeur", item.value)
                    )
                    .foregroundStyle(by: .value("Label", item.label))
                    .foregroundStyle(.primary)
                    .annotation(position: .overlay) {
                        Text("\(item.value)")
                            .foregroundStyle(.white)
                            .font(.caption)
                    }
                }
                .chartLegend(position: .bottom, alignment: .center)
                .frame(height: 300)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)).shadow(radius: 4))
            .padding()
        }
    }
}

private struct StatTile: View {
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
