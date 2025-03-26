//
//  SeriesPageView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import SwiftUI

struct DiscoverDetailView: View {
    
    @StateObject var viewModel: DiscoverDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: viewModel.serie.poster)) { image in
                    image.resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(height: 300)
                .clipped()
                .cornerRadius(12)
                .shadow(radius: 5)
                
                HStack {
                    Text(viewModel.serie.title)
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Text(String(format: "%.1f ★", viewModel.serie.note))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.yellow.opacity(0.8))
                        .cornerRadius(8)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.serie.kinds, id: \.self) { kind in
                            Text(kind)
                                .font(.caption)
                                .padding(6)
                                .background(.black.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    DetailRow(title: "Saisons :", value: "\(viewModel.serie.seasons)")
                    DetailRow(title: "Episodes :", value: "\(viewModel.serie.episodes)")
                    DetailRow(title: "Durée :", value: "\(viewModel.serie.duration) mins")
                    DetailRow(title: "Pays :", value: viewModel.serie.country)
                    DetailRow(title: "Platforme :", value: viewModel.serie.network)
                    DetailRow(title: "Status :", value: viewModel.serie.status)
                    DetailRow(title: "Création :", value: viewModel.serie.creation)
                }
                
                if !viewModel.serie.platforms.isEmpty {
                    Text("Platformes :")
                        .font(.headline)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.serie.platforms, id: \.name) { platform in
                                VStack {
                                    AsyncImage(url: URL(string: platform.logo)) { image in
                                        image.resizable()
                                            .scaledToFit()
                                    } placeholder: {
                                        Color.gray.opacity(0.3)
                                    }
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(8)
                                    Text(platform.name)
                                        .font(.caption)
                                }
                                .padding(.horizontal, 8)
                            }
                        }
                    }
                }
                
                Text("Description")
                    .font(.headline)
                Text(viewModel.serie.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                
            }
            .padding()
        }
        .navigationTitle(viewModel.serie.title)
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.semibold)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    DiscoverDetailView(viewModel: .mock)
}
