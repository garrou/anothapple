//
//  SerieDetailView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 25/03/2025.
//

import SwiftUI

struct SerieDetailView: View {
    
    @StateObject var viewModel: SerieDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                AsyncImage(url: URL(string: viewModel.serie.poster)) { image in
                    image.resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 5)
                
                HStack {
                    Text(viewModel.serie.title)
                        .font(.title)
                        .bold()
                    
                    Spacer()
                    
                    if viewModel.serie.favorite {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                    }
                }
                
                Text(viewModel.serie.country)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                WrapView(items: viewModel.serie.kinds) { kind in
                    Text(kind)
                        .font(.caption)
                        .padding(6)
                        .background(.black.opacity(0.2))
                        .cornerRadius(8)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "clock")
                        Text("\(viewModel.serie.duration) min")
                    }
                    
                    HStack {
                        Image(systemName: "film.stack")
                        Text("\(viewModel.serie.seasons) Season(s)")
                    }
                    
                    HStack {
                        Image(systemName: viewModel.serie.watch ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(viewModel.serie.watch ? .green : .gray)
                        Text(viewModel.serie.watch ? "Vue" : "Pas vue")
                    }
                }
                .font(.subheadline)
                .foregroundColor(.gray)
                
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - WrapView for Tags

struct WrapView<Data: Hashable, Content: View>: View {
    let items: [Data]
    let content: (Data) -> Content
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(items, id: \.self) { item in
                        content(item)
                    }
                }
            }
        }
    }
}

#Preview {
    SerieDetailView(viewModel: .mock)
}
