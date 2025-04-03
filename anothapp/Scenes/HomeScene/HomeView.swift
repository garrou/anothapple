//
//  HomePageView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            TabView(selection: $viewModel.selectedTab) {
                viewModel.getSeriesTabView()
                    .tabItem {
                        Label("Mes séries", systemImage: "play.rectangle")
                    }
                    .tag(AppTab.series)
                
                viewModel.getDiscoverTabView()
                    .tabItem {
                        Label("Découvrir", systemImage: "magnifyingglass")
                    }
                    .tag(AppTab.discover)
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
                        VStack(alignment: .leading) {
                            
                            Spacer().frame(height: 120)
                            
                            List {
                                NavigationLink(destination: viewModel.getWatchListView()) {
                                    Label("Ma liste", systemImage: "list.bullet")
                                }
                                NavigationLink(destination: Text("Option 2 View")) {
                                    Label("Séries à continuer", systemImage: "play")
                                }
                                NavigationLink(destination: Text("Option 2 View")) {
                                    Label("Historique", systemImage: "calendar.day.timeline.left")
                                }
                                NavigationLink(destination: viewModel.getFavoritesView()) {
                                    Label("Favoris", systemImage: "heart")
                                }
                                NavigationLink(destination: Text("Option 3 View")) {
                                    Label("Séries arrêtées", systemImage: "pause")
                                }
                                NavigationLink(destination: Text("Option 3 View")) {
                                    Label("Calendrier", systemImage: "calendar")
                                }
                                NavigationLink(destination: Text("Option 3 View")) {
                                    Label("Paramètres", systemImage: "gear")
                                }
                                Button(action: { viewModel.logout() }) {
                                    HStack {
                                        Image(systemName: "arrow.left.to.line").padding(.leading, 5)
                                        Text("Se déconnecter")
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())
                            .frame(maxHeight: .infinity)
                        }
                        .frame(width: 250)
                        .background(Color(UIColor.systemBackground))
                        .edgesIgnoringSafeArea(.all)
                        
                        Spacer() // Drawer to the left
                    }
                    .transition(.move(edge: .leading))
                }.zIndex(1)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    withAnimation {
                        viewModel.isMenuOpened.toggle()
                    }
                }) {
                    Image(systemName: viewModel.isMenuOpened ? "xmark" : "line.horizontal.3")
                        .font(.title2)
                }
            }
        }
    }
}

#Preview {
    HomeView(viewModel: .mock)
}
