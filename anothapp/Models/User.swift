//
//  User.swift
//  anothapp
//
//  Created by Adrien Garrouste on 23/03/2025.
//

struct User: Codable, Hashable {
    let token: String
    let id: String
    let email: String
    let picture: String?
    let username: String
}
