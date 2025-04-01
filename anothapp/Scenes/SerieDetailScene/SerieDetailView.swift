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
                    ImageCardView(url: viewModel.serie.poster)
                    //                        .frame(height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 5)
                    
                    HScrollItems(items: viewModel.serie.kinds) { kind in
                        Text(kind)
                            .font(.caption)
                            .padding(6)
                            .background(.black.opacity(0.2))
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        HStack {
                            Image(systemName: "flag")
                            Text(viewModel.serie.country)
                                .font(.subheadline)
                        }
                        
                        HStack {
                            Image(systemName: "clock")
                            Text("\(viewModel.serie.duration) mins / épisode")
                        }
                        
                        HStack {
                            Image(systemName: "film.stack")
                            Text("\(viewModel.infos.seasons.count) / \(viewModel.serie.seasons) saison(s)")
                        }
                        
                        HStack {
                            Image(systemName: "timer")
                            Text("\(viewModel.infos.time) mins de visionnage")
                        }
                        
                        if viewModel.serie.favorite {
                            HStack {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                                Text("Série dans vos favoris")
                            }
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    
                    // Tabs
                    Picker("", selection: $viewModel.selectedTab) {
                        Image(systemName: "square.grid.2x2").tag(SerieDetailTab.seasons)
                        Image(systemName: "play.square.stack").tag(SerieDetailTab.add)
                        Image(systemName: "person.3").tag(SerieDetailTab.viewedBy)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    TabView(selection: $viewModel.selectedTab) {
                        
                        // User seasons
                        GridView(items: viewModel.infos.seasons, columns: 2) { season in
                            SeasonCardView(season: season)
                        }
                        .tag(SerieDetailTab.seasons)
                        .background(
                            GeometryReader { geometry in
                                Color.clear.preference(
                                    key: ContentHeightPreferenceKey.self,
                                    value: geometry.size.height
                                )
                            }
                        )
                        .onAppear {
                            Task {
                                await viewModel.getSerieInfos()
                            }
                        }
                        
                        // Seasons to add
                        GridView(items: viewModel.seasons, columns: 2) { season in
                            SeasonCardView(season: season) {
                                HStack {
                                    Button(action: {
                                        Task {
                                            await viewModel.addSeason(season: season)
                                        }
                                    }) {
                                        Image(systemName: "plus.square")
                                            .font(.system(size: 15, weight: .regular))
                                            .foregroundColor(.black)
                                    }.padding()
                                    
                                    Button(action: {
                                        print("episodes")
                                    }) {
                                        Image(systemName: "list.number")
                                            .font(.system(size: 15, weight: .regular))
                                    }.padding()
                                }
                            }
                        }
                        .tag(SerieDetailTab.add)
                        .background(
                            GeometryReader { geometry in
                                Color.clear.preference(
                                    key: ContentHeightPreferenceKey.self,
                                    value: geometry.size.height
                                )
                            }
                        )
                        .onAppear {
                            Task {
                                await viewModel.getSeasonsToAdd()
                            }
                        }
                        
                        // Friends who watched this serie
                        GridView(items: viewModel.viewedByFriends, columns: 2) { friend in
                            Button(action: { print("user") })
                            {
                                CardView(picture: friend.picture, text: friend.username).padding(.all, 2)
                            }
                        }
                        .tag(SerieDetailTab.viewedBy)
                        .background(
                            GeometryReader { geometry in
                                Color.clear.preference(
                                    key: ContentHeightPreferenceKey.self,
                                    value: geometry.size.height
                                )
                            }
                        )
                        .onAppear {
                            Task {
                                await viewModel.getFriendsWhoWatch()
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .onPreferenceChange(ContentHeightPreferenceKey.self) { height in
                        withAnimation {
                            if abs(viewModel.tabContentHeight - height) > 1 {
                                viewModel.tabContentHeight = height
                            }
                        }
                    }
                    .frame(minHeight: viewModel.tabContentHeight)
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
                            
                            // Discover details
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
                                
                                // Stop watching
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
                                
                                // Favorite
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
                                
                                //Delete
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
        }
        .tint(.black)
        .toast(message: viewModel.message, isShowing: $viewModel.showToast)
    }
}

struct HScrollItems<Data: Hashable, Content: View>: View {
    let items: [Data]
    let content: (Data) -> Content
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(items, id: \.self) { item in
                    content(item)
                }
            }
        }
    }
}

struct SeasonCardView<Content: View>: View {
    
    let season: Season
    let content: Content
    private let defaultRadius = 10.0
    
    init(season: Season, @ViewBuilder content: () -> Content = { EmptyView() }) {
        self.season = season
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 2) {
            CardView(picture: season.image, text: "Saison \(season.number)")
            
            HStack {
                Text("\(season.episodes) épisodes")
                    .font(.caption)
                    .foregroundColor(.black)
                
                Text("(\(season.interval))")
                    .font(.caption)
                    .foregroundColor(.black)
            }
            
            content
        }
    }
}


#Preview {
    SerieDetailView(viewModel: .mock)
}
