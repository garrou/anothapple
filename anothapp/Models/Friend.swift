//
//  Friend.swift
//  anothapp
//
//  Created by Adrien Garrouste on 30/03/2025.
//

struct Friend: Codable, Hashable {
    let id: String
    let email: String
    let username: String
    let picture: String?
    let current: Bool
}

struct ViewedByFriends: Codable {
    let friends: [Friend]
    
    enum CodingKeys: String, CodingKey {
        case friends = "viewed"
    }
}

struct SummaryFriends: Codable {
    let friends: [Friend]
    let received: [Friend]
    let sent: [Friend]
}
