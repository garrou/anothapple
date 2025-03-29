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
                    
                    // Tabs
                    Picker("", selection: $viewModel.selectedTab) {
                        Image(systemName: "square.grid.2x2").tag(SerieDetailTab.seasons)
                        Image(systemName: "play.square.stack").tag(SerieDetailTab.add)
                        Image(systemName: "person.3").tag(SerieDetailTab.viewedBy)
                    }.pickerStyle(SegmentedPickerStyle()).padding().frame(height: 50)
                    
                    TabView(selection: $viewModel.selectedTab) {
                        //                        GridView(items: viewModel.infos.seasons, columns: 2) { season in
                        //                            SeasonCard(season: season)
                        //                        }.tag(SerieDetailTab.seasons)
                        
                        
                        Text("Saisons")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.red.opacity(0.3))
                            .tag(SerieDetailTab.seasons)
                        
                        Text("Ajouter")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.green.opacity(0.3))
                            .tag(SerieDetailTab.add)
                        
                        Text("Vue par")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.blue.opacity(0.3))
                            .tag(SerieDetailTab.viewedBy)
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
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
        }.onAppear {
            Task {
                await viewModel.getSerieInfos()
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

struct SeasonCard: View {
    let season: Season
    
    var body: some View {
        Button(action: {
            print("season")
        })
        {
            VStack {
                ImageCardView(imageUrl: season.image)
                Text("Saison \(season.number)").font(.headline).multilineTextAlignment(.center).foregroundColor(.black)
            }
        }
    }
}

#Preview {
    SerieDetailView(viewModel: .mock)
}
