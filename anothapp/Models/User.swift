//
//  User.swift
//  anothapp
//
//  Created by Adrien Garrouste on 23/03/2025.
//

struct User: Codable, Hashable {
    let token: String
    let id: String
    var email: String
    var picture: String?
    var username: String
}

struct ProfilePictureRequest: Codable {
    let image: String
}

struct ProfilePasswordRequest: Codable {
    let currentPassword: String
    let newPassword: String
    let confirmPassword: String
}

struct ProfileEmailRequest: Codable {
    let email: String
    let newEmail: String
}
