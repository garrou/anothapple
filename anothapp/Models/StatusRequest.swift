//
//  StatusRequest.swift
//  anothapp
//
//  Created by Adrien Garrouste on 28/03/2025.
//

import Foundation

struct StatusRequest : Codable {
    var favorite: Bool? = nil
    var watch: Bool? = nil
    var addedAt: Date? = nil
    var note: Int? = nil
    
    enum CodingKeys: String, CodingKey {
        case favorite, watch, addedAt, note
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(favorite, forKey: .favorite)
        try container.encode(watch, forKey: .watch)
        try container.encode(note, forKey: .note)
        
        if let addedAt = addedAt {
            let dateString = Helper.shared.dateToString(date: addedAt, format: "yyyy-MM-dd HH:mm:ss")
            try container.encode(dateString, forKey: .addedAt)
        }
    }
}

