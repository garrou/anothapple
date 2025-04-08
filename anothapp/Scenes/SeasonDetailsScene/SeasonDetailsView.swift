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
            
            HStack {
                Text(Helper.shared.formatPlural(str: "visionnage", num: viewModel.seasons.count))
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(viewModel.viewingTime)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
            )
            .padding(.horizontal)
            
            GridView(items: viewModel.seasons, columns: 1) { season in
                Menu {
                    ForEach(viewModel.platforms, id: \.id!) { platform in
                        Button(action: {
                            Task {
                                await viewModel.updateSeasonPlatform(seasonId: season.id, platformId: platform.id!)
                            }
                        }) {
                            HStack {
                                ImageCardView(url: platform.logo)
                                Text(platform.name).font(.caption)
                            }
                        }
                    }
                } label: {
                    HStack {
                        if season.platform.logo.isEmpty {
                            Image(systemName: "play")
                                .resizable()
                                .frame(width: 50, height: 50)
                        } else {
                            ImageCardView(url: season.platform.logo)
                                .frame(width: 100, height: 100)
                        }
                        
                        Spacer()
                        
                        Text("\(Helper.shared.dateToString(date: season.addedAt, style: .medium))")
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                )
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 10)
        .task {
            await viewModel.loadSeasonDetails()
        }
    }
}

#Preview {
    SeasonDetailsView(viewModel: .mock)
}
