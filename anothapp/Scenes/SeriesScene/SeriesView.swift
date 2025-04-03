//
//  SeriesPageView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import SwiftUI

struct SeriesView: View {
    
    @StateObject var viewModel: SeriesViewModel
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
                .onChange(of: viewModel.titleSearch) {
                    Task {
                        await viewModel.loadSeries()
                    }
                }
            
            if viewModel.isLoading {
                LoadingView()
            } else {
                Text("\(viewModel.series.count) séries")
                    .font(.subheadline)
                
                GridView(items: viewModel.series, columns: 2) { serie in
                    Button(action: {
                        viewModel.routeToSerieDetail(serie: serie)
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
        .onAppear {
            Task {
                await viewModel.loadData()
            }
        }
    }
}

#Preview {
    SeriesView(viewModel: .mock)
}

