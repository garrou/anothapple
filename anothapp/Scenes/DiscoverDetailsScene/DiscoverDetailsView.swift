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
                
                ImageCardView(url: viewModel.serie.poster)
                
                // Tabs
                Picker("", selection: $viewModel.selectedTab) {
                    Image(systemName: "info.circle").tag(DiscoverDetailsTab.details)
                    Image(systemName: "list.bullet").tag(DiscoverDetailsTab.similars)
                    Image(systemName: "photo.stack").tag(DiscoverDetailsTab.images)
                    Image(systemName: "person.3").tag(DiscoverDetailsTab.characters)
                    Image(systemName: "person.fill.checkmark").tag(DiscoverDetailsTab.friends)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                TabView(selection: $viewModel.selectedTab) {
                    
                    // Details
                    VStack(alignment: .leading, spacing: 16) {
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
                                        .background(.primary.opacity(0.2))
                                        .cornerRadius(8)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            DetailRow(title: "Saisons", value: "\(viewModel.serie.seasons)")
                            DetailRow(title: "Episodes", value: "\(viewModel.serie.episodes)")
                            DetailRow(title: "Durée", value: "\(viewModel.serie.duration) mins")
                            DetailRow(title: "Pays", value: viewModel.serie.country)
                            DetailRow(title: "Platforme", value: viewModel.serie.network)
                            DetailRow(title: "Status", value: viewModel.serie.status)
                            DetailRow(title: "Création", value: "\(viewModel.serie.creation)")
                            
                            if !viewModel.serie.platforms.isEmpty {
                                Text("Plateformes")
                                    .fontWeight(.semibold)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(viewModel.serie.platforms, id: \.name) { platform in
                                            VStack {
                                                ImageCardView(url: platform.logo)
                                                    .frame(width: 100, height: 100)
                                                Text(platform.name)
                                                    .font(.caption)
                                            }
                                            .padding(.horizontal, 8)
                                        }
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
                    .tag(DiscoverDetailsTab.details)
                    .background(
                        GeometryReader { geometry in
                            Color.clear.preference(
                                key: ContentHeightPreferenceKey.self,
                                value: geometry.size.height * 1.1 // TODO ???
                            )
                        }
                    )
                    
                    // Similars
                    GridView(items: viewModel.similars, columns: 1) { similar in
                        Button(action: {
                            Task {
                                await viewModel.routeToDiscoverDetails(id: similar.id)
                            }
                        })
                        {
                            Text(similar.title)
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .border(Color(.separator), width: 0.5)
                        }
                    }
                    .tag(DiscoverDetailsTab.similars)
                    .background(
                        GeometryReader { geometry in
                            Color.clear.preference(
                                key: ContentHeightPreferenceKey.self,
                                value: geometry.size.height
                            )
                        }
                    )
                    .task {
                        await viewModel.getSimilarsSeries()
                    }
                    
                    // Images
                    GridView(items: viewModel.images, columns: 2) { image in
                        Button(action: { print("image") })
                        {
                            ImageCardView(url: image)
                        }
                    }
                    .tag(DiscoverDetailsTab.images)
                    .background(
                        GeometryReader { geometry in
                            Color.clear.preference(
                                key: ContentHeightPreferenceKey.self,
                                value: geometry.size.height
                            )
                        }
                    )
                    .task {
                        await viewModel.getSerieImages()
                    }
                    
                    // Actors
                    GridView(items: viewModel.characters, columns: 2) { character in
                        Button(action: { print("actor") })
                        {
                            VStack {
                                if let img = character.picture {
                                    ImageCardView(url: img)
                                }
                                Text(character.actor).font(.headline)
                                Text(character.name).font(.subheadline)
                            }
                        }
                    }
                    .tag(DiscoverDetailsTab.characters)
                    .background(
                        GeometryReader { geometry in
                            Color.clear.preference(
                                key: ContentHeightPreferenceKey.self,
                                value: geometry.size.height
                            )
                        }
                    )
                    .task {
                        await viewModel.getCharacters()
                    }
                    
                    // Friends who watch
                    GridView(items: viewModel.viewedByFriends, columns: 2) { friend in
                        Button(action: { print("user") })
                        {
                            CardView(picture: friend.picture, text: friend.username).padding(.all, 2)
                        }
                    }
                    .tag(DiscoverDetailsTab.friends)
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
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .onPreferenceChange(ContentHeightPreferenceKey.self) { height in
                    
                    if abs(viewModel.tabContentHeight - height) > 1 {
                        viewModel.tabContentHeight = height
                    }
                    
                }
                .frame(minHeight: viewModel.tabContentHeight)
            }
            .padding()
            
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
