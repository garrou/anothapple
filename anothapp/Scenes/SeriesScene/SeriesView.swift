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
                .padding(.all, 5)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSearchFocused ? .black : .gray.opacity(0.5), lineWidth: 1)
                )
                .padding(.horizontal, 10)
                .focused($isSearchFocused)
                .onChange(of: viewModel.titleSearch) {
                    Task {
                        await viewModel.loadSeries()
                    }
                }
            
            if viewModel.series.isEmpty {
                Text("Aucune série")
            } else {
                HStack {
                    Text("\(viewModel.series.count) séries")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(.black))
                        .shadow(radius: 5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.padding(.leading, 10)
            }
            
            
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

