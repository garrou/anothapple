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
    }
}

private struct FriendsTabView: View {
    
    @StateObject var viewModel: FriendsViewModel
    
    var body: some View {
        VStack {
            Text(Helper.shared.formatPlural(str: "ami", num: viewModel.friends.count)).font(.headline)
            
            GridView(items: viewModel.friends, columns: 2) { friend in
                CardView(picture: friend.picture, text: friend.username) {
                    HStack(spacing: 30) {
                        Button(action: { viewModel.showDeleteFriendModal.toggle() }) {
                            Image(systemName: "trash")
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(.red)
                        }
                        .alert("Supprimer l'ami(e) ?", isPresented: $viewModel.showDeleteFriendModal) {
                            Button("Annuler", role: .cancel) { viewModel.showDeleteFriendModal.toggle() }
                            Button("Supprimer", role: .destructive) {
                                Task {
                                    await viewModel.removeFriend(userId: friend.id, status: .friends)
                                }
                            }
                        }
                        
                        Button(action: { viewModel.openFriendDetailsView(userId: friend.id) }) {
                            Image(systemName: "eye")
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(.primary)
                        }
                    }.padding(.top, 1)
                }
            }
            Spacer()
        }
        .task {
            await viewModel.getFriends()
        }
        .sheet(isPresented: $viewModel.openFriendDetails, onDismiss: { viewModel.closeFriendDetails() }) {
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: { viewModel.closeFriendDetails() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.primary)
                    }
                }.padding()
                
                viewModel.getDashboardView()
            }
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
            
            GridView(items: viewModel.searchFriends, columns: 2) { user in
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
            
            GridView(items: viewModel.receivedFriends, columns: 2) { friend in
                CardView(picture: friend.picture, text: friend.username) {
                    HStack(spacing: 30) {
                        Button(action: { viewModel.showDeleteReceivedModal.toggle() }) {
                            Image(systemName: "trash")
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(.red)
                        }
                        .alert("Supprimer la demande reçue ?", isPresented: $viewModel.showDeleteReceivedModal) {
                            Button("Annuler", role: .cancel) { viewModel.showDeleteReceivedModal.toggle() }
                            Button("Supprimer", role: .destructive) {
                                Task {
                                    await viewModel.removeFriend(userId: friend.id, status: .received)
                                }
                            }
                        }
                        
                        Button(action: {
                            Task {
                                await viewModel.acceptFriend(userId: friend.id)
                            }
                        }) {
                            Image(systemName: "checkmark.circle")
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(.green)
                        }
                        
                    }
                    .padding(.top, 1)
                }
            }
            
            Spacer()
        }
        .task {
            await viewModel.getReceivedFriendsRequest()
        }
    }
}

private struct SentTabView: View {
    
    @StateObject var viewModel: FriendsViewModel
    
    var body: some View {
        VStack {
            Text("Demandes envoyées").font(.headline)
            
            GridView(items: viewModel.sentFriends, columns: 2) { friend in
                CardView(picture: friend.picture, text: friend.username) {
                    Button(action: { viewModel.showDeleteSentModal.toggle() }) {
                        Image(systemName: "trash")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.red)
                    }
                    .padding(.top, 1)
                    .alert("Supprimer la demande envoyée ?", isPresented: $viewModel.showDeleteSentModal) {
                        Button("Annuler", role: .cancel) { viewModel.showDeleteSentModal.toggle() }
                        Button("Supprimer", role: .destructive) {
                            Task {
                                await viewModel.removeFriend(userId: friend.id, status: .sent)
                            }
                        }
                    }
                }
            }
            
            Spacer()
        }
        .task {
            await viewModel.getSentFriendsRequest()
        }
    }
}
