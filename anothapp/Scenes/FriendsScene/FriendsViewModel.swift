//
//  FriendsViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 23/05/2025.
//

import Foundation
import SwiftUI

enum FriendsTab {
    case friends, add, received, sent
}

class FriendsViewModel: ObservableObject {
    
    private let router: FriendsRouter

    @Published var selectedTab: FriendsTab = .friends
    @Published var usernameSearch = ""
    @Published var friends: [Friend] = []
    @Published var searchFriends: [Friend] = []
    @Published var sentFriends: [Friend] = []
    @Published var receivedFriends: [Friend] = []
    @Published var showDeleteFriendModal = false
    @Published var showDeleteSentModal = false
    @Published var showDeleteReceivedModal = false
    @Published var openFriendDetails = false
    @Published var friendIdToConsult: String? = nil
    
    init(router: FriendsRouter) {
        self.router = router
    }
    
    func sendFriendRequest(userId: String) async {
        await FriendsManager.shared.sendFriendRequest(userId: userId)
    }
    
    func getDashboardView() -> AnyView {
        if let id = friendIdToConsult {
            return router.getDashboardView(userId: id)
        }
        return AnyView(EmptyView())
    }
    
    func openFriendDetailsView(userId: String) {
        openFriendDetails = true
        friendIdToConsult = userId
    }
    
    func closeFriendDetails() {
        openFriendDetails = false
        friendIdToConsult = nil
    }
    
    @MainActor
    func removeFriend(userId: String, status: FriendStatus) async {
        let removed = await FriendsManager.shared.removeFriend(userId: userId)
        if !removed { return }
        
        if status == .sent {
            sentFriends.removeAll { $0.id == userId }
        } else if status == .received {
            receivedFriends.removeAll { $0.id == userId }
        } else if status == .friends {
            friends.removeAll { $0.id == userId }
        }
    }
    
    func acceptFriend(userId: String) async {
        let accepted = await FriendsManager.shared.acceptFriend(userId: userId)
        if accepted {
            selectedTab = .friends
        }
    }
    
    @MainActor
    func getSentFriendsRequest() async {
        sentFriends = await FriendsManager.shared.getFriendsByStatus(status: .sent)
    }
    
    @MainActor
    func getReceivedFriendsRequest() async {
        receivedFriends = await FriendsManager.shared.getFriendsByStatus(status: .received)
    }
    
    @MainActor
    func getUsersByUsername() async {
        searchFriends = await UserManager.shared.getUsersByUsername(username: usernameSearch)
    }
    
    @MainActor
    func getFriends() async {
        friends = await FriendsManager.shared.getFriendsByStatus(status: .friends)
    }
}
