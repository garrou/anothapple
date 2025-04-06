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
            
            Text(Helper.shared.formatPlural(str: "visionnage", num: viewModel.seasons.count))
                .font(.headline)
                .foregroundColor(.primary)
            
            
            Text(viewModel.viewingTime)
                .font(.headline)
                .foregroundColor(.primary)
            
            GridView(items: viewModel.seasons, columns: 2) { season in
                VStack {
                    if season.platform.logo.isEmpty {
                        Image(systemName: "play.circle")
                        Text(season.platform.name)
                    } else {
                        ImageCardView(url: season.platform.logo)
                    }
                    Text("\(Helper.shared.dateToString(date: season.addedAt, style: .medium))")
                }
                
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
