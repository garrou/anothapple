//
//  Episode.swift
//  anothapp
//
//  Created by Adrien Garrouste on 03/04/2025.
//

import Foundation

struct Episode: Codable, Hashable {
    let id: Int
    let title: String
    let code: String
    let global: Int
    let description: String
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case id, title, code, global, description, date
    }
    
    init(id: Int, title: String, code: String, global: Int, description: String, date: Date) {
        self.id = id
        self.title = title
        self.code = code
        self.global = global
        self.description = description
        self.date = date
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.code = try container.decode(String.self, forKey: .code)
        self.global = try container.decode(Int.self, forKey: .global)
        self.description = try container.decode(String.self, forKey: .description)
        
        let dateString = try container.decode(String.self, forKey: .date)
        date = try Formatter.shared.stringToDate(str: dateString, format: "yyyy-MM-dd")
    }
}
