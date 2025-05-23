//
//  SerieService.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import Foundation

class FriendService {
    
    private let baseUrl = "\(BaseService.serverUrl)/friends"
    private let decoder: JSONDecoder = JSONDecoder()
    
    func fetchUsersWhoWatch(id: Int) async throws -> ViewedByFriends? {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)?status=viewed&serieId=\(id)")
        return ok ? try decoder.decode(ViewedByFriends.self, from: data) : nil
    }
    
    func fetchSummaryFriends() async throws -> SummaryFriends? {
        let (data, ok) = try await BaseService.shared.request(url: "\(baseUrl)")
        return ok ? try decoder.decode(SummaryFriends.self, from: data) : nil
    }
}
