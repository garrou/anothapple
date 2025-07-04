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
                    .shadow(color: Color.primary.opacity(0.3), radius: 5, x: 0, y: 2)
            )
            .padding(.horizontal)
            
            GridView(items: viewModel.seasons, columns: 1) { season in
                HStack {
                    Menu {
                        ForEach(viewModel.platforms, id: \.id!) { platform in
                            Button(action: { viewModel.selectPlatformId(seasonId: season.id, platformId: platform.id!) }) {
                                HStack {
                                    ImageCardView(url: platform.logo)
                                    Text(platform.name).font(.caption)
                                }
                            }
                        }
                    } label: {
                        ImageCardView(url: season.platform.logo)
                            .frame(width: 50, height: 50)
                    }
                    
                    Spacer()
                    
                    DatePicker("", selection: viewModel.bindingForDate(season.id), in: ...Date())
                    
                    Spacer()
                    
                    Button(action: { viewModel.showDeleteModal.toggle() }) {
                        Image(systemName: "trash").foregroundColor(.red).font(.system(size: 20))
                    }.alert("Supprimer la saison ?", isPresented: $viewModel.showDeleteModal) {
                        Button("Annuler", role: .cancel) { viewModel.showDeleteModal.toggle() }
                        Button("Supprimer", role: .destructive) {
                            Task {
                                await viewModel.deleteSeason(id: season.id)
                            }
                        }
                    }
                    
                    Button(action: {
                        Task {
                            await viewModel.updateSeason(seasonId: season.id)
                        }
                    }) {
                        Image(systemName: "checkmark.circle").foregroundColor(.green).font(.system(size: 20))
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.primary.opacity(0.3), radius: 5, x: 0, y: 2)
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
