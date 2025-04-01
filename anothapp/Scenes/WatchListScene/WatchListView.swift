//
//  WatchListView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 01/04/2025.
//

import SwiftUI

struct WatchListView: View {
    
    @StateObject var viewModel: WatchListViewModel
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                LoadingView()
            } else {
                GridView(items: viewModel.series, columns: 2) { serie in
                    Button(action: {
                        Task {
                            await viewModel.routeToDiscoverDetails(serie: serie)
                        }
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
        .navigationTitle("\(viewModel.series.count) série(s)")
        .onAppear {
            Task {
                await viewModel.loadWatchList()
            }
        }
    }
}

#Preview {
    WatchListView(viewModel: .mock)
}
