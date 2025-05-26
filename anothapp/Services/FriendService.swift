//
//  SerieService.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import Foundation

enum FriendStatus: String {
    case sent = "sent"
    case received = "received"
    case friends = "friends"
    case viewed = "viewed"
}

class FriendService {
    
    private let baseUrl = "\(BaseService.serverUrl)/friends"
    private let decoder: JSONDecoder = JSONDecoder()
    
    func fetchUsersWhoWatch(id: Int) async throws -> ViewedByFriends? {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)?status=\(FriendStatus.viewed.rawValue)&serieId=\(id)")
        return ok ? try decoder.decode(ViewedByFriends.self, from: data) : nil
    }
    
    func fetchSummaryFriends() async throws -> SummaryFriends? {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)")
        return ok ? try decoder.decode(SummaryFriends.self, from: data) : nil
    }
    
    func sendFriendRequest(request: FriendRequest) async throws -> Bool {
        let (_, ok) = try await BaseService.shared.dataRequest(url: "\(baseUrl)", method: "POST", data: request)
        return ok
    }
    
    func removeFriend(userId: String) async throws -> Bool {
        let (_, ok) = try await BaseService.shared.request(url: "\(baseUrl)/\(userId)", method: "DELETE", successCode: 204)
        return ok
    }
    
    func acceptFriend(request: FriendRequest) async throws -> Bool {
        let (_, ok) = try await BaseService.shared.dataRequest(url: "\(baseUrl)/\(request.userId)", method: "PATCH", data: request)
        return ok
    }
    
    func fetchFriendsByStatus(status: FriendStatus) async throws -> SummaryFriends? {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)?status=\(status.rawValue)")
        return ok ? try decoder.decode(SummaryFriends.self, from: data) : nil
    }
}
