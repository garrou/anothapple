//
//  SeriesPageView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import SwiftUI

struct DiscoverDetailsView: View {
    
    @StateObject var viewModel: DiscoverDetailsViewModel
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    AsyncImage(url: URL(string: viewModel.serie.poster)) { image in
                        image.resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(height: 300)
                    .clipped()
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    
                    Text(String(format: "%.1f ★", viewModel.serie.note))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.yellow.opacity(0.8))
                        .cornerRadius(8)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.serie.kinds, id: \.self) { kind in
                                Text(kind)
                                    .font(.caption)
                                    .padding(6)
                                    .background(.black.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        DetailRow(title: "Saisons :", value: "\(viewModel.serie.seasons)")
                        DetailRow(title: "Episodes :", value: "\(viewModel.serie.episodes)")
                        DetailRow(title: "Durée :", value: "\(viewModel.serie.duration) mins")
                        DetailRow(title: "Pays :", value: viewModel.serie.country)
                        DetailRow(title: "Platforme :", value: viewModel.serie.network)
                        DetailRow(title: "Status :", value: viewModel.serie.status)
                        DetailRow(title: "Création :", value: viewModel.serie.creation)
                    }
                    
                    if !viewModel.serie.platforms.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.serie.platforms, id: \.name) { platform in
                                    VStack {
                                        AsyncImage(url: URL(string: platform.logo)) { image in
                                            image.resizable()
                                                .scaledToFit()
                                        } placeholder: {
                                            Color.gray.opacity(0.3)
                                        }
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(8)
                                        Text(platform.name)
                                            .font(.caption)
                                    }
                                    .padding(.horizontal, 8)
                                }
                            }
                        }
                    }
                    
                    Text("Description")
                        .font(.headline)
                    Text(viewModel.serie.synopsis)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                }
                .padding()
            }
            
            // Right drawer
            if viewModel.isMenuOpened {
                ZStack {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                viewModel.isMenuOpened.toggle()
                            }
                        }
                    
                    HStack {
                        
                        Spacer() // Drawer to the right
                        
                        VStack(alignment: .trailing) {
                            
                            Spacer().frame(height: 80)
                            
                            List {
                                // Add serie
                                if !viewModel.isSerieAdded {
                                    Button(action: {
                                        Task {
                                            await viewModel.addSerie()
                                        }
                                    }) {
                                        HStack {
                                            Image(systemName: "plus.square")
                                            Text("Ajouter dans mes séries")
                                        }
                                    }
                                }
                                // Add in list
                                Button(action: {
                                    Task {
                                        await viewModel.changeInList()
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: viewModel.isSerieInList ? "text.badge.minus" : "text.badge.plus")
                                        Text(viewModel.isSerieInList ? "Supprimer de ma liste" : "Ajouter dans la liste")
                                    }
                                }
                                
                                Button(action: {
                                    print("viewed by")
                                }) {
                                    HStack {
                                        Image(systemName: "person.3")
                                        Text("Vus par")
                                    }
                                }
                                
                                Button(action: {
                                    print("characters")
                                }) {
                                    HStack {
                                        Image(systemName: "person.crop.rectangle.stack")
                                        Text("Acteurs")
                                    }
                                }
                                
                                Button(action: {
                                    print("similars")
                                }) {
                                    HStack {
                                        Image(systemName: "equal.square")
                                        Text("Séries similaires")
                                    }
                                }
                                
                                Button(action: {
                                    print("images")
                                }) {
                                    HStack {
                                        Image(systemName: "photo")
                                        Text("Images")
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())
                            .frame(maxHeight: .infinity)
                        }
                        .frame(width: 200)
                        .background(Color(UIColor.systemBackground))
                        .edgesIgnoringSafeArea(.all)
                    }
                    .transition(.move(edge: .trailing))
                }.zIndex(10)
            }
        }
        .navigationTitle(viewModel.serie.title)
        .navigationBarHidden(viewModel.isMenuOpened)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.isMenuOpened.toggle()
                }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.title2)
                }
            }
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.semibold)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    DiscoverDetailsView(viewModel: .mock)
}
