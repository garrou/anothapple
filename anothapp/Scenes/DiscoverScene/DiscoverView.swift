//
//  SeriesPageView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import SwiftUI

struct DiscoverView: View {
    
    @StateObject var viewModel: DiscoverViewModel
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        ScrollView {
            
            TextField("Titre de la série", text: $viewModel.titleSearch)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSearchFocused ? .primary : .secondary, lineWidth: 1)
                )
                .padding(.horizontal, 10)
                .focused($isSearchFocused)
                .onSubmit {
                    Task {
                        await viewModel.loadSeries()
                    }
                }
            
            if viewModel.isLoading {
                LoadingView()
            } else if viewModel.series.isEmpty {
                Text("Aucune série disponible")
            } else {
                GridView(items: viewModel.series, columns: 2) { serie in
                    Button(action: {
                        Task {
                            await viewModel.routeToDiscoverDetail(id: serie.id)
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
        .task {
            await viewModel.loadSeries()
        }
    }
}

#Preview {
    DiscoverView(viewModel: .mock)
}

