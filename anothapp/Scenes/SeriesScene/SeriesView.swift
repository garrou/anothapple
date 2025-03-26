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
            GridView(items: viewModel.series, columns: 2) { serie in
                SerieCardView(serie: serie, buttonAction: { viewModel.routeToSerieDetail(serie)
                })
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

