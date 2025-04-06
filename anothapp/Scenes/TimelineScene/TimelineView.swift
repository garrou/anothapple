//
//  TimelineView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 04/04/2025.
//


import SwiftUI

struct TimelineView: View {
    
    @StateObject var viewModel: TimelineViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                ForEach(viewModel.seasons, id: \.self) { item in
                    Button(action: {
                        viewModel.routeToSerieDetails(id: item.showId)
                    }) {
                        TimelineItemView(item: item)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Historique")
        .task {
            await viewModel.loadTimeline()
        }
    }
}


struct TimelineItemView: View {
    
    let item: Timeline
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .trailing) {
                Text(Helper.shared.dateToString(date: item.addedAt, style: .medium))
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Circle()
                    .fill(.primary)
                    .frame(width: 10, height: 10)
            }
            .frame(width: 80)
            
            VStack(alignment: .leading, spacing: 8) {
                ImageCardView(url: item.season.image)
                
                Text(item.showTitle)
                    .font(.headline)
                
                Text("Season \(item.season.number) • \(item.season.episodes) episodes")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    TimelineView(viewModel: .mock)
}
