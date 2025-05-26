//
//  Friend.swift
//  anothapp
//
//  Created by Adrien Garrouste on 30/03/2025.
//

import Foundation

struct Friend: Codable, Hashable {
    let id: String
    let email: String
    let username: String
    let picture: String?
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
    
    enum CodingKeys: String, CodingKey {
        case friends, received, sent
    }
    
    init(friends: [Friend], received: [Friend], sent: [Friend]) {
        self.friends = friends
        self.received = received
        self.sent = sent
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        friends = (try? container.decode([Friend].self, forKey: .friends)) ?? []
        received = (try? container.decode([Friend].self, forKey: .received)) ?? []
        sent = (try? container.decode([Friend].self, forKey: .sent)) ?? []
    }
}

struct FriendRequest: Codable {
    let userId: String
}
