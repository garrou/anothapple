//
//  ApiSerieTest.swift
//  anothapp
//
//  Created by Adrien Garrouste on 20/06/2025.
//

import XCTest
@testable import anothapp

class ApiSerieTest: XCTestCase {
    
    private let decoder = JSONDecoder()
    
    func testDeserializeSerie() throws {
        let jsonSerie = """
        {
            "id": 33104,
            "title": "Daredevil: Born Again",
            "poster": "https://pictures.betaseries.com/fonds/poster/1b03b1f37e10c1eb8d675f869bc4adcd.jpg",
            "duration": 40,
            "country": "États-Unis",
            "description": "Aveugle depuis ses neuf ans à la suite d'un accident, Matt Murdock bénéficie d'une acuité extraordinaire de ses autres sens. Avocat le jour, il devient le super-héros Daredevil lorsque la nuit tombe, afin de lutter contre l’injustice à New York, plus particulièrement dans le quartier de Hell's Kitchen, corrompu par la criminalité depuis sa reconstruction après l'attaque des Chitauris (lors des événements du film Avengers).",
            "seasons": 1,
            "episodes": 9,
            "network": "Disney+",
            "note": 4.1006,
            "status": "En cours",
            "creation": 2025,
            "kinds": [ "Action", "Drame" ],
            "platforms": [
                {
                    "name": "Disney+",
                    "logo": "https://pictures.betaseries.com/platforms/246.jpg"
                }, 
                {
                    "name": "Canal+ Ciné Séries",
                    "logo": "https://pictures.betaseries.com/platforms/278.jpg"
                }
            ]
        }
        """
        
        let jsonData = try XCTUnwrap(jsonSerie.data(using: .utf8))
        let serie = try decoder.decode(ApiSerie.self, from: jsonData)
        
        XCTAssertEqual(serie.id, 33104)
        XCTAssertEqual(serie.title, "Daredevil: Born Again")
        XCTAssertFalse(serie.description.isEmpty)
        XCTAssertFalse(serie.poster.isEmpty)
        
        XCTAssertEqual(serie.kinds.count, 2)
        XCTAssertEqual(serie.kinds[0], "Action")
        XCTAssertEqual(serie.kinds[1], "Drame")
        
        XCTAssertEqual(serie.seasons, 1)
        XCTAssertEqual(serie.episodes, 9)
        XCTAssertEqual(serie.duration, 40)
        XCTAssertEqual(serie.creation, 2025)
        XCTAssertEqual(serie.platforms.count, 2)
        
        XCTAssertEqual(serie.platforms[0].name, "Disney+")
        XCTAssertEqual(serie.platforms[1].name, "Canal+ Ciné Séries")
    }
    
    func testDeserializeSerieWithInvalidJson() {
        let invalidJson = """
        {
            "status": 12,
            "title": "Daredevil: Born Again"
        }
        """
        
        let jsonData = invalidJson.data(using: .utf8)!
        
        XCTAssertThrowsError(try decoder.decode(ApiSerie.self, from: jsonData)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func testDeserializeSerieWithMissingRequiredFields() {
        let incompleteJson = """
        {
            "id": 33104,
            "title": "Daredevil: Born Again",
            "poster": "https://pictures.betaseries.com/fonds/poster/1b03b1f37e10c1eb8d675f869bc4adcd.jpg",
            "duration": 40,
            "country": "États-Unis",
            "description": "Aveugle depuis ses neuf ans à la suite d'un accident, Matt Murdock bénéficie d'une acuité extraordinaire de ses autres sens. Avocat le jour, il devient le super-héros Daredevil lorsque la nuit tombe, afin de lutter contre l’injustice à New York, plus particulièrement dans le quartier de Hell's Kitchen, corrompu par la criminalité depuis sa reconstruction après l'attaque des Chitauris (lors des événements du film Avengers).",
            "seasons": 1,
            "network": "Disney+",
            "note": 4.1006,
            "status": "En cours",
            "creation": 2025,
            "kinds": [ "Action", "Drame" ],
            "platforms": [
                {
                    "name": "Disney+",
                    "logo": "https://pictures.betaseries.com/platforms/246.jpg"
                }, 
                {
                    "name": "Canal+ Ciné Séries",
                    "logo": "https://pictures.betaseries.com/platforms/278.jpg"
                }
            ]
        }
        """
        
        let jsonData = incompleteJson.data(using: .utf8)!
        
        XCTAssertThrowsError(try decoder.decode(ApiSerie.self, from: jsonData)) { error in
            XCTAssertTrue(error is DecodingError)
            if case DecodingError.keyNotFound(let key, _) = error {
                XCTAssertEqual(key.stringValue, "episodes")
            }
        }
    }
}
