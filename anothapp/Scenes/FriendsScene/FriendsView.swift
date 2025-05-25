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

private struct FriendsTabView: View {
    
    @StateObject var viewModel: FriendsViewModel
    
    var body: some View {
        VStack {
            Text(Helper.shared.formatPlural(str: "ami", num: viewModel.summary.friends.count)).font(.headline)
            
            GridView(items: viewModel.summary.friends, columns: 2) { friend in
                CardView(picture: friend.picture, text: friend.username) {
                    HStack(spacing: 30) {
                        Button(action: { viewModel.showDeleteModal.toggle() }) {
                            Image(systemName: "trash")
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(.red)
                        }
                        .alert("Supprimer l'ami(e) ?", isPresented: $viewModel.showDeleteModal) {
                            Button("Annuler", role: .cancel) { viewModel.showDeleteModal.toggle() }
                            Button("Supprimer", role: .destructive) {
                                Task {
                                    await viewModel.removeFriend(userId: friend.id)
                                }
                            }
                        }
                        
                        Button(action: { print("details") }) {
                            Image(systemName: "eye")
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(.primary)
                        }
                    }.padding(.top, 1)
                }
            }
            Spacer()
        }
    }
}

private struct AddTabView: View {
    
    @StateObject var viewModel: FriendsViewModel
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        VStack {
            Text("Ajouter des amis").font(.headline)
            
            TextField("Nom d'utilisateur", text: $viewModel.usernameSearch)
                .padding(.all, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSearchFocused ? .primary : .secondary, lineWidth: 1)
                )
                .focused($isSearchFocused)
                .onSubmit {
                    Task {
                        await viewModel.getUsersByUsername()
                    }
                }
                .padding()
            
            GridView(items: viewModel.users, columns: 2) { user in
                VStack {
                    CardView(picture: user.picture, text: user.username) {
                        Button(action: {
                            Task {
                                await viewModel.sendFriendRequest(userId: user.id)
                            }
                        }) {
                            Image(systemName: "plus.square")
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(.primary)
                        }.padding(.top, 1)
                    }
                }
            }
            
            Spacer()
        }
    }
}

private struct ReceivedTabView: View {
    
    @StateObject var viewModel: FriendsViewModel
    
    var body: some View {
        VStack {
            Text("Demandes reçues").font(.headline)
            
            GridView(items: viewModel.summary.received, columns: 2) { friend in
                CardView(picture: friend.picture, text: friend.username)
            }
            
            Spacer()
        }
    }
}

private struct SentTabView: View {
    
    @StateObject var viewModel: FriendsViewModel
    
    var body: some View {
        VStack {
            Text("Demandes envoyées").font(.headline)
            
            GridView(items: viewModel.summary.sent, columns: 2) { friend in
                CardView(picture: friend.picture, text: friend.username)
            }
            
            Spacer()
        }
    }
}
