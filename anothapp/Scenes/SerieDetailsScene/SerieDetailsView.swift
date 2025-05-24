//
//  SerieDetailView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 25/03/2025.
//

import SwiftUI

struct SerieDetailsView: View {
    
    @StateObject var viewModel: SerieDetailsViewModel
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ImageCardView(url: viewModel.serie.poster)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 5)
                    
                    HScrollItems(items: viewModel.serie.kinds) { kind in
                        Text(kind)
                            .font(.caption)
                            .padding(6)
                            .background(.secondary.opacity(0.2))
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
                            Text("\(viewModel.infos.seasons.count) / " + Helper.shared.formatPlural(str: "saison", num: viewModel.serie.seasons))
                        }
                        
                        HStack {
                            Image(systemName: "timer")
                            Text("\(Helper.shared.formatMins(viewModel.infos.time)) de visionnage")
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
                    
                    Picker("", selection: $viewModel.selectedTab) {
                        Image(systemName: "square.grid.2x2").tag(SerieDetailsTab.seasons)
                        
                        Image(systemName: "play.square.stack").tag(SerieDetailsTab.add)
                        
                        Image(systemName: "person.fill.checkmark").tag(SerieDetailsTab.viewedBy)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    TabView(selection: $viewModel.selectedTab) {
                        
                        UserSeasonsView(viewModel: viewModel).tag(SerieDetailsTab.seasons)
                        
                        AddSeasonsView(viewModel: viewModel).tag(SerieDetailsTab.add)
                        
                        FriendsWatchView(viewModel: viewModel).tag(SerieDetailsTab.viewedBy)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .onPreferenceChange(ContentHeightPreferenceKey.self) { height in
                        if abs(viewModel.tabContentHeight - height) > 1 {
                            viewModel.tabContentHeight = height
                            
                        }
                    }
                    .frame(minHeight: viewModel.tabContentHeight)
                }
                .padding()
            }
            
            // Right drawer
            if viewModel.isMenuOpened {
                ZStack {
                    Color.primary.opacity(0.3)
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
                                        Image(systemName: "info.circle")
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
                                        Image(systemName: viewModel.serie.favorite ? "heart.fill" : "heart")
                                            .foregroundColor(viewModel.serie.favorite ? .red : .primary)
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
                    withAnimation {
                        viewModel.isMenuOpened.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.title2)
                }
            }
        }
    }
}

private struct UserSeasonsView: View {
    
    @StateObject var viewModel: SerieDetailsViewModel
    
    var body: some View {
        GridView(items: viewModel.infos.seasons, columns: 2) { season in
            Button(action: {
                viewModel.routeToSeasonDetails(season: season)
            }) {
                SeasonCardView(season: season)
            }
        }
        .background(
            GeometryReader { geometry in
                Color.clear.preference(
                    key: ContentHeightPreferenceKey.self,
                    value: geometry.size.height
                )
            }
        )
        .task {
            await viewModel.getSerieInfos()
        }
    }
}

private struct AddSeasonsView: View {
    
    @StateObject var viewModel: SerieDetailsViewModel
    
    var body: some View {
        GridView(items: viewModel.seasons, columns: 2) { season in
            SeasonCardView(season: season) {
                HStack {
                    Button(action: {
                        Task {
                            await viewModel.addSeason(season: season)
                        }
                    }) {
                        Image(systemName: "plus.square")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.primary)
                    }.padding()
                    
                    Button(action: {
                        viewModel.routeToEpisodesView(season: season.number)
                    }) {
                        Image(systemName: "list.number")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.primary)
                    }.padding()
                }
            }
        }
        .background(
            GeometryReader { geometry in
                Color.clear.preference(
                    key: ContentHeightPreferenceKey.self,
                    value: geometry.size.height
                )
            }
        )
        .task {
            await viewModel.getSeasonsToAdd()
        }
    }
}

private struct FriendsWatchView: View {
    
    @StateObject var viewModel: SerieDetailsViewModel
    
    var body: some View {
        GridView(items: viewModel.viewedByFriends, columns: 2) { friend in
            Button(action: { print("user") })
            {
                CardView(picture: friend.picture, text: friend.username).padding(.all, 2)
            }
        }
        .background(
            GeometryReader { geometry in
                Color.clear.preference(
                    key: ContentHeightPreferenceKey.self,
                    value: geometry.size.height
                )
            }
        )
        .task {
            await viewModel.getFriendsWhoWatch()
        }
    }
}

private struct HScrollItems<Data: Hashable, Content: View>: View {
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

private struct SeasonCardView<Content: View>: View {
    
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
                
                Text("(\(season.interval))")
                    .font(.caption)
            }
            
            content
        }
    }
}


#Preview {
    SerieDetailsView(viewModel: .mock)
}
