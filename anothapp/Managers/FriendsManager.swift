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
    
    func sendFriendRequest(userId: String) async {
        do {
            let added = try await friendService.sendFriendRequest(request: .init(userId: userId))
            ToastManager.shared.setToast(message: added ? "Demande envoyé" : "Erreur durant la demande", isError: !added)
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la demande d'ajout")
        }
    }
    
    func removeFriend(userId: String) async -> Bool {
        var removed = false
        
        do {
            removed = try await friendService.removeFriend(userId: userId)
            ToastManager.shared.setToast(message: removed ? "Ami(e) supprimé(e)" : "Erreur durant la suppression", isError: !removed)
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la suppression")
        }
        return removed
    }
    
    func acceptFriend(userId: String) async -> Bool {
        var accepted = false
        
        do {
            accepted = try await friendService.acceptFriend(request: .init(userId: userId))
            ToastManager.shared.setToast(message: accepted ? "Ami(e) accepté(e)" : "Erreur durant l'ajout", isError: !accepted)
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la suppression")
        }
        return accepted
    }
    
    func getFriendsByStatus(status: FriendStatus) async -> [Friend] {
        var friends: [Friend] = []
        
        do {
            if let summary = try await friendService.fetchFriendsByStatus(status: status) {
                friends = (Mirror(reflecting: summary).children.first { $0.label == status.rawValue }?.value as? [Friend]) ?? []
            }
        } catch {
            ToastManager.shared.setToast(message: "Erreur durant la récupération des amis avec le status '\(status.rawValue)'")
        }
        return friends
    }
}
