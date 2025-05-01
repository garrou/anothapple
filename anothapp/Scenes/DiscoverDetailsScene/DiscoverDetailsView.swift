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
                        Button(action: {
                            Task {
                                await viewModel.getActorDetails(id: character.id)
                            }
                        })
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
                    .sheet(isPresented: $viewModel.openActorDetails) {
                        ActorDetailView(viewModel: viewModel, person: viewModel.selectedActor!)
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

struct ActorDetailView : View {
    
    let viewModel: DiscoverDetailsViewModel
    let person: PersonDetails
    
    var body: some View {
        ScrollView {
            headerSection
            
            VStack(alignment: .leading, spacing: 24) {
                basicInfoSection
                
                descriptionSection
                
                seriesSection
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
    }
    
    private var headerSection: some View {
        ZStack(alignment: .bottom) {
   
            if let posterUrl = person.poster {
                ImageCardView(url: posterUrl)
            } else {
                Rectangle()
                    .fill(LinearGradient(colors: [.blue.opacity(0.7), .purple.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 280)
            }
            
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 280)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(person.name)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                Text(person.nationality)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
    
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Information")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary)
            
            HStack(spacing: 24) {
                infoItem(title: "Naissance", value: person.birthday)
                
                if let deathday = person.deathday {
                    infoItem(title: "Décès", value: deathday)
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private func infoItem(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Description")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary)
            
            Text(person.description)
                .font(.system(size: 16))
                .foregroundColor(.primary)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private var seriesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Séries")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary)
            
            if person.series.isEmpty {
                Text("Aucune série")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
            } else {
                GridView(items: person.series, columns: 2) { serie in
                    Button(action: {
                        Task {
                            viewModel.openActorDetails = false
                            await viewModel.routeToDiscoverDetails(id: serie.id)
                        }
                    })
                    {
                        VStack {
                            ImageCardView(url: serie.poster)
                            Text(serie.title).font(.headline)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    DiscoverDetailsView(viewModel: .mock)
}
