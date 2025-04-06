//
//  ListView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 28/03/2025.
//

import SwiftUI

struct SeriesStatusView: View {
    
    @StateObject var viewModel: SeriesStatusViewModel
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                LoadingView()
            } else {
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
        .navigationTitle(viewModel.title)
    }
}

#Preview {
    SeriesStatusView(viewModel: .mock)
}
