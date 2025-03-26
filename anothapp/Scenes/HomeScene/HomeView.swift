//
//  HomePageView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel: HomeViewModel
    @State private var selectedTab: AppTab = .series
    
    var body: some View {
        TabView(selection: $selectedTab) {
            viewModel.getSeriesTabView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(AppTab.series)
            
            viewModel.getDiscoverTabView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Discover")
                }
                .tag(AppTab.discover)
        }.tint(.black)
    }
}
#Preview {
    HomeView(viewModel: .mock)
}
