//
//  FriendsView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 23/05/2025.
//

import SwiftUI

struct FriendsView: View {
    
    @StateObject var viewModel: FriendsViewModel
    
    var body: some View {
        VStack {
            Picker("", selection: $viewModel.selectedTab) {
                Image(systemName: "person.fill.checkmark").tag(FriendsTab.friends)
                Image(systemName: "person.badge.plus").tag(FriendsTab.add)
                Image(systemName: "arrow.down.circle").tag(FriendsTab.received)
                Image(systemName: "arrow.up.circle").tag(FriendsTab.sent)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            TabView(selection: $viewModel.selectedTab) {
                
                FriendsTabView(viewModel: viewModel).tag(FriendsTab.friends)
                
                AddTabView(viewModel: viewModel).tag(FriendsTab.add)
                
                ReceivedTabView(viewModel: viewModel).tag(FriendsTab.received)
                
                SentTabView(viewModel: viewModel).tag(FriendsTab.sent)
            }
        }
        .task {
            await viewModel.loadSummaryFriends()
        }
    }
}

struct FriendsTabView: View {
    
    let viewModel: FriendsViewModel
    
    var body: some View {
        VStack {
            GridView(items: viewModel.summary.friends, columns: 2) { friend in
                VStack {
                    if let img = friend.picture {
                        ImageCardView(url: img)
                    }
                    Text(friend.username).font(.headline)
                    Text(friend.email).font(.subheadline)
                }
            }
            
            Spacer()
        }
    }
}

struct AddTabView: View {
    
    let viewModel: FriendsViewModel
    
    var body: some View {
        VStack {
            Text("Ajouter")
            
            Spacer()
        }
    }
}

struct ReceivedTabView: View {
    
    let viewModel: FriendsViewModel
    
    var body: some View {
        VStack {
            Text("Demandes reçues")
            
            GridView(items: viewModel.summary.received, columns: 2) { friend in
                VStack {
                    if let img = friend.picture {
                        ImageCardView(url: img)
                    }
                    Text(friend.username).font(.headline)
                    Text(friend.email).font(.subheadline)
                }
            }
            
            Spacer()
        }
    }
}

struct SentTabView: View {
    
    let viewModel: FriendsViewModel
    
    var body: some View {
        VStack {
            Text("Demandes envoyées")
            
            GridView(items: viewModel.summary.sent, columns: 2) { friend in
                VStack {
                    if let img = friend.picture {
                        ImageCardView(url: img)
                    }
                    Text(friend.username).font(.headline)
                    Text(friend.email).font(.subheadline)
                }
            }
            
            Spacer()
        }
    }
}
