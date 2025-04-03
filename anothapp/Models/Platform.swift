//
//  Platform.swift
//  anothapp
//
//  Created by Adrien Garrouste on 03/04/2025.
//

import Foundation

class Platform: NSObject, Codable {
    var id: Int?
    let name: String
    let logo: String
    
    init(id: Int, name: String, logo: String) {
        self.id = id
        self.name = name
        self.logo = logo
    }
}
