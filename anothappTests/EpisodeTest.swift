//
//  EpisodeTest.swift
//  anothapp
//
//  Created by Adrien Garrouste on 03/04/2025.
//

import XCTest
@testable import anothapp

class EpisodeTest: XCTestCase {
    
    private let decoder = JSONDecoder()
    
    func testDeserializeEpisode() throws {
        let jsonEpisode = """
        {
            "id": 472993,
            "title": "eps1.0_hellofriend.mov",
            "code": "S01E01",
            "global": 1,
            "description": "Elliot, ingénieur en cyber-sécurité le jour et hacker justicier la nuit, est recruté par un mystérieux groupe clandestin pour détruire l'entreprise qui l'a payé pour la protéger. Elliot doit décider jusqu'où il ira pour exposer les forces qui, pense-t-il, dirigent (et ruinent) le monde.",
            "date": "2015-06-24"
        }
        """
        
        let episode = try? decoder.decode(Episode.self, from: jsonEpisode.data(using: .utf8)!)
        XCTAssertNotNil(episode)
    }
}
