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
            if viewModel.isLoading {
                LoadingView()
            } else {
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
                    
//                    Text("Friends")
//                        .tabItem {
//                            Label("Amis", systemImage: "person.3")
//                        }
//                        .tag(AppTab.friends)
                    
                    viewModel.getStatisticsTabView()
                        .tabItem {
                            Label("Statistiques", systemImage: "chart.pie")
                        }
                        .tag(AppTab.statistics)
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
                                    Button(action: { Task { await viewModel.routeToWatchListView() }}) {
                                        Label("Ma liste", systemImage: "list.bullet")
                                    }
                                    Button(action: { Task { await viewModel.routeToSeriesToContinueView() }}) {
                                        Label("Séries en cours", systemImage: "play")
                                    }
                                    Button(action: { viewModel.routeToTimelineView() }) {
                                        Label("Historique", systemImage: "calendar.day.timeline.left")
                                    }
                                    Button(action: { viewModel.routeToFavoritesView() }) {
                                        Label("Favoris", systemImage: "heart")
                                    }
                                    Button(action: { viewModel.routeToStoppedSeriesView() }) {
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
                    }
                    .zIndex(1)
                }
            }
        }
        .task {
            await viewModel.loadCaches()
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
