//
//  SeriesPageView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import SwiftUI

struct DiscoverView: View {
    
    @StateObject var viewModel: DiscoverViewModel
    
    var body: some View {
        ScrollView {
            
            if viewModel.isLoading {
                LoadingView()
            } else if viewModel.series.isEmpty {
                Text("Aucune série disponible")
            } else {
                GridView(items: viewModel.series, columns: 2) { serie in
                    Button(action: {
                        viewModel.routeToDiscoverDetail(serie: serie)
                    })
                    {
                        VStack {
                            ImageCardView(url: serie.poster)
                            Text(serie.title).font(.headline)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 10)
        .navigationTitle("Découvrir")
        .task {
            await viewModel.loadDiscoverSeries(limit: 20)
        }
    }
}

#Preview {
    DiscoverView(viewModel: .mock)
}

