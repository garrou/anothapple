//
//  FriendsCacheManager.swift
//  anothapp
//
//  Created by Adrien Garrouste on 30/03/2025.
//

import Foundation

class FriendsManager {

    static let shared = FriendsManager()
    private let friendService = FriendService()

    func getFriendsWhoWatch(id: Int) async -> [Friend] {
        var friends: [Friend] = []
        
        do {
            if let viewedBy = try await friendService.fetchUsersWhoWatch(id: id) {
                friends = viewedBy.friends
            }
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la récupération des amis")
        }
        return friends
    }
    
    func getSummaryFriends() async -> SummaryFriends {
        var summaryFriends: SummaryFriends = .init(friends: [], received: [], sent: [])
        
        do {
            if let summary = try await friendService.fetchSummaryFriends() {
                summaryFriends = summary
            }
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la récupération des amis")
        }
        return summaryFriends
    }
}
