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
        let viewedBy = try? await friendService.fetchUsersWhoWatch(id: id)
        return viewedBy?.friends ?? []
    }
}
