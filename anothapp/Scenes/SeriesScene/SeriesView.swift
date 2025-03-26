//
//  SeriesPageView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import SwiftUI

struct SeriesView: View {
    
    @StateObject var viewModel: SeriesViewModel
    
    var body: some View {
        ScrollView {
            // manage no series case
            GridView(items: viewModel.series, columns: 2) { serie in
                Button(action: {
                    viewModel.routeToSerieDetail(serie: serie)
                })
                {
                    VStack {
                        ImageCardView(imageUrl: serie.poster)
                        Text(serie.title).font(.headline).multilineTextAlignment(.center).foregroundColor(.black)
                    }
                }
            }
        }
        .padding(.vertical, 10)
        .onAppear {
            Task {
                await viewModel.loadSeries()
            }
        }
    }
}

#Preview {
    SeriesView(viewModel: .mock)
}

