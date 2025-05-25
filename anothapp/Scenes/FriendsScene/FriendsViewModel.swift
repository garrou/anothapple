//
//  FriendsViewModel.swift
//  anothapp
//
//  Created by Adrien Garrouste on 23/05/2025.
//

import Foundation

enum FriendsTab {
    case friends, add, received, sent
}

class FriendsViewModel: ObservableObject {
    
    private let router: FriendsRouter

    @Published var summary: SummaryFriends = .init(friends: [], received: [], sent: [])
    @Published var selectedTab: FriendsTab = .friends
    @Published var usernameSearch = ""
    @Published var users: [Friend] = []
    @Published var showDeleteModal = false
    
    init(router: FriendsRouter) {
        self.router = router
    }
    
    func sendFriendRequest(userId: String) async {
        await FriendsManager.shared.sendFriendRequest(userId: userId)
    }
    
    func removeFriend(userId: String) async {
        await FriendsManager.shared.removeFriend(userId: userId)
    }
    
    @MainActor
    func getUsersByUsername() async {
        users = await UserManager.shared.getUsersByUsername(username: usernameSearch)
    }
    
    @MainActor
    func loadSummaryFriends() async {
        summary = await FriendsManager.shared.getSummaryFriends()
    }
}
