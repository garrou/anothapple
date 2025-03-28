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
        ZStack {
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
                        //                    Text(viewModel.serie.title)
                        //                        .font(.title)
                        //                        .bold()
                        
                        //                    Spacer()
                        
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
                        
                        //                    HStack {
                        //                        Image(systemName: "timer")
                        //                        Text("\() temps total")
                        //                    }
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    
                    TabView(selection: $viewModel.selectedTab) {
                        Text("Mes saisons")
                            .tabItem {
                                Label("Tab 1", systemImage: "1.circle")
                            }.tag(SerieDetailTab.seasons)
                        
                        Text("Ajouter")
                            .tabItem {
                                Label("Tab 2", systemImage: "2.circle")
                            }.tag(SerieDetailTab.add)
                        
                        Text("Vue par")
                            .tabItem {
                                Label("Tab 3", systemImage: "3.circle")
                            }.tag(SerieDetailTab.viewedBy)
                    }
                    .frame(maxHeight: .infinity)
                    .padding(.top, 40)
                    .background(.white)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .frame(maxWidth: .infinity)
                }
                .padding()
            }
            
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
                                Button(action: {
                                    Task {
                                        await viewModel.routeToDiscoverDetails()
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "info.circle").foregroundColor(.black)
                                        Text("Informations")
                                    }
                                }
                                
                                Button(action: {
                                    Task {
                                        await viewModel.changeWatching()
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: viewModel.serie.watch ? "pause" : "play").foregroundColor(viewModel.serie.watch ? .red : .green)
                                        Text("\(viewModel.serie.watch ? "Arrêter" : "Reprendre")")
                                    }
                                }
                                
                                Button(action: {
                                    Task {
                                        await viewModel.changeFavorite()
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: viewModel.serie.favorite ? "heart.fill" : "heart").foregroundColor(viewModel.serie.favorite ? .red : .black)
                                        Text(viewModel.serie.favorite ? "Supprimer" : "Ajouter")
                                    }
                                }
                                
                                Button(action: { viewModel.showDeleteModal.toggle() }) {
                                    HStack {
                                        Image(systemName: "trash").foregroundColor(.red)
                                        Text("Supprimer")
                                    }
                                }.alert("Supprimer la série ?", isPresented: $viewModel.showDeleteModal) {
                                    Button("Annuler", role: .cancel) {
                                        viewModel.showDeleteModal.toggle()
                                    }
                                    Button("Supprimer", role: .destructive) {
                                        Task {
                                            await viewModel.deleteSerie()
                                        }
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())
                            .frame(maxHeight: .infinity)
                        }
                        .frame(width: 200)
                        .background(.white)
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
                    withAnimation {
                        viewModel.isMenuOpened.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.title2)
                }
            }
        }.tint(.black)
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
