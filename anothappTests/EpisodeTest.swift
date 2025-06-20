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
        
        let jsonData = try XCTUnwrap(jsonEpisode.data(using: .utf8))
        let episode = try decoder.decode(Episode.self, from: jsonData)
        
        XCTAssertEqual(episode.id, 472993)
        XCTAssertEqual(episode.title, "eps1.0_hellofriend.mov")
        XCTAssertEqual(episode.code, "S01E01")
        XCTAssertEqual(episode.global, 1)
        XCTAssertEqual(episode.description, "Elliot, ingénieur en cyber-sécurité le jour et hacker justicier la nuit, est recruté par un mystérieux groupe clandestin pour détruire l'entreprise qui l'a payé pour la protéger. Elliot doit décider jusqu'où il ira pour exposer les forces qui, pense-t-il, dirigent (et ruinent) le monde.")
        
        let date = try Helper.shared.stringToDate(str: "2015-06-24", format: "yyyy-MM-dd")
        XCTAssertEqual(episode.date, date)
    }
    
    func testDeserializeEpisodeWithInvalidJson() {
        let invalidJson = """
        {
            "id": "not_a_number",
            "title": "eps1.0_hellofriend.mov"
        }
        """
        
        let jsonData = invalidJson.data(using: .utf8)!
        
        XCTAssertThrowsError(try decoder.decode(Episode.self, from: jsonData)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func testDeserializeEpisodeWithMissingRequiredFields() {
        let incompleteJson = """
        {
            "id": 472993,
            "title": "eps1.0_hellofriend.mov",
            "code": "S01E01",
            "global": 1,
            "date": "2015-06-24"
        }
        """
        
        let jsonData = incompleteJson.data(using: .utf8)!
        
        XCTAssertThrowsError(try decoder.decode(Episode.self, from: jsonData)) { error in
            XCTAssertTrue(error is DecodingError)
            if case DecodingError.keyNotFound(let key, _) = error {
                XCTAssertEqual(key.stringValue, "description")
            }
        }
    }
    
    func testDeserializeEpisodeArray() throws {
        let jsonEpisodes = """
        [
            {
                "id": 472993,
                "title": "eps1.0_hellofriend.mov",
                "code": "S01E01",
                "global": 1,
                "description": "Episode 1 description",
                "date": "2015-06-24"
            },
            {
                "id": 472994,
                "title": "eps1.1_ones-and-zer0es.mpeg",
                "code": "S01E02",
                "global": 2,
                "description": "Episode 2 description",
                "date": "2015-07-01"
            }
        ]
        """
        
        let jsonData = try XCTUnwrap(jsonEpisodes.data(using: .utf8))
        let episodes = try decoder.decode([Episode].self, from: jsonData)
        
        XCTAssertEqual(episodes.count, 2)
        XCTAssertEqual(episodes[0].id, 472993)
        XCTAssertEqual(episodes[1].id, 472994)
        XCTAssertEqual(episodes[0].title, "eps1.0_hellofriend.mov")
        XCTAssertEqual(episodes[1].title, "eps1.1_ones-and-zer0es.mpeg")
        XCTAssertEqual(episodes[0].code, "S01E01")
        XCTAssertEqual(episodes[1].code, "S01E02")
    }
}
