//
//  EpisodesView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 03/04/2025.
//

import SwiftUI

struct EpisodesView: View {
    
    @StateObject var viewModel: EpisodesViewModel
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                LoadingView()
            } else {
                GridView(items: viewModel.episodes, columns: 2) { episode in
                    EpisodeView(episode: episode)
                }
            }
        }
        .padding(.vertical, 10)
        .navigationTitle("Saison \(viewModel.season) - \(viewModel.episodes.count) épisodes")
        .task {
            await viewModel.loadEpisodes()
        }
    }
}

struct EpisodeView: View {
    let episode: Episode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(episode.title)
                .font(.headline)
                .foregroundColor(.primary)

            Text(episode.code)
                .font(.subheadline)
                .foregroundColor(.primary.opacity(0.8))

            Text(episode.description)
                .font(.footnote)
                .foregroundColor(.primary.opacity(0.7))

            Spacer()
            
            HStack {
                Text("\(Helper.shared.dateToString(date: episode.date, style: .medium))")
                    .font(.caption)
                    .foregroundColor(.primary.opacity(0.8))
                
                Spacer()
                
                Text("#\(episode.global)")
                    .font(.caption)
                    .bold()
                    .foregroundColor(.primary)
                    .padding(6)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 120)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}


#Preview {
    EpisodesView(viewModel: .mock)
}
