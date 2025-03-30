//
//  ListView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 28/03/2025.
//

import SwiftUI

struct FavoritesView: View {
    
    @StateObject var viewModel: FavoritesViewModel
    
    var body: some View {
        ScrollView {
            if viewModel.series.isEmpty {
                Text("Aucun favori")
            } else {
                GridView(items: viewModel.series, columns: 2) { serie in
                    Button(action: {
                        viewModel.routeToSerieDetail(serie: serie)
                    })
                    {
                        VStack {
                            ImageCardView(url: serie.poster)
                            Text(serie.title).font(.headline).foregroundColor(.black)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 10)
        .navigationTitle("\(viewModel.series.count) favori(s)")
        .onAppear {
            Task {
                viewModel.loadFavorites()
            }
        }
    }
}

#Preview {
    FavoritesView(viewModel: .mock)
}
