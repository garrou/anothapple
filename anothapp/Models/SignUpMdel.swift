//
//  SignUpRequest.swift
//  anothapp
//
//  Created by Adrien Garrouste on 23/03/2025.
//

struct SignUpModel: Codable {
    let email: String
    let username: String
    let password: String
    let confirm: String
}
