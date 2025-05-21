//
//  Character.swift
//  anothapp
//
//  Created by Adrien Garrouste on 15/04/2025.
//

struct Person: Codable, Hashable {
    
    let id: Int
    
    let name: String
    
    let actor: String
    
    let picture: String?
}


struct PersonDetails: Codable {
    
    let id: Int
    
    let name: String
    
    let birthday: String?
    
    let deathday: String?
    
    let nationality: String?
    
    let description: String
    
    let poster: String?
    
    let series: [PersonSerie]
}

struct PersonSerie: Codable, Hashable {
    
    let id: Int
    
    let title: String
    
    let creation: Int
    
    let poster: String
    
    let seasons: Int
    
    let episodes: Int
}
