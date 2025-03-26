//
//  HomePageView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel: HomeViewModel
    @State var selectedTab: AppTab = .series
    
    var body: some View {
        TabView(selection: $selectedTab) {
            viewModel.getSeriesTabView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(AppTab.series)
            
            viewModel.getDisordersTabView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Discover")
                }
                .tag(AppTab.series)
        }
    }
}
#Preview {
    HomeView(viewModel: .mock)
}
