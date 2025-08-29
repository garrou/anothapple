//
//  SerieTest.swift
//  anothapp
//
//  Created by Adrien Garrouste on 29/03/2025.
//

import XCTest
@testable import anothapp

class SerieTest: XCTestCase {
    
    private let decoder = JSONDecoder()
    
    func testDeserializeSerie() throws {
        let jsonSerie = """
        {
            "id": 1,
            "title": "Test",
            "poster": "https://picsum.photos/200", 
            "kinds": ["Action"], 
            "favorite": false, 
            "duration": 45, 
            "addedAt": "2025-02-12T13:12:58.024Z" , 
            "country": "France", 
            "watch": true, 
            "seasons": 2,
            "note": 3
        }
        """
        
        let jsonData = try XCTUnwrap(jsonSerie.data(using: .utf8))
        let serie = try decoder.decode(Serie.self, from: jsonData)
        
        XCTAssertEqual(serie.id, 1)
        XCTAssertEqual(serie.title, "Test")
        XCTAssertFalse(serie.poster.isEmpty)
        XCTAssertEqual(serie.kinds.count, 1)
        XCTAssertFalse(serie.favorite)
        XCTAssertEqual(serie.duration, 45)
        XCTAssertEqual(serie.note, 3)
        
        let date = try Helper.shared.stringToDate(str: "2025-02-12T13:12:58.024Z")
        XCTAssertEqual(serie.addedAt, date)
        XCTAssertEqual(serie.country, "France")
        XCTAssertTrue(serie.watch)
        XCTAssertEqual(serie.seasons, 2)
    }
    
    func testDeserializeSerieWithInvalidJson() {
        let invalidJson = """
        {
            "id": "not_a_number",
            "title": "Test"
        }
        """
        
        let jsonData = invalidJson.data(using: .utf8)!
        
        XCTAssertThrowsError(try decoder.decode(Episode.self, from: jsonData)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func testDeserializeSerieWithMissingRequiredFields() {
        let incompleteJson = """
        {
            "id": 1,    
            "poster": "https://picsum.photos/200", 
            "kinds": ["Action"], 
            "favorite": false, 
            "duration": 45, 
            "addedAt": "2025-02-12T13:12:58.024Z" , 
            "country": "France", 
            "watch": true, 
            "seasons": 2
        }
        """
        
        let jsonData = incompleteJson.data(using: .utf8)!
        
        XCTAssertThrowsError(try decoder.decode(Episode.self, from: jsonData)) { error in
            XCTAssertTrue(error is DecodingError)
            if case DecodingError.keyNotFound(let key, _) = error {
                XCTAssertEqual(key.stringValue, "title")
            }
        }
    }
    
    func testDeserializeSerieMissingOptionalFields() throws {
        let jsonSerie = """
        {
            "id": 1,
            "title": "Test",
            "poster": "https://picsum.photos/200", 
            "kinds": ["Action"], 
            "duration": 45, 
            "addedAt": "2025-02-12T13:12:58.024Z" , 
            "country": "France", 
            "seasons": 2
        }
        """
        
        let jsonData = try XCTUnwrap(jsonSerie.data(using: .utf8))
        let serie = try decoder.decode(Serie.self, from: jsonData)
        
        XCTAssertFalse(serie.favorite)
        XCTAssertFalse(serie.watch)
    }
    
    func testDeserializeSerieInfos() throws {
        let jsonSerieInfos = """
        {
            "seasons": [
                {
                    "number": 1,
                    "episodes": 10,
                    "image": "https://pictures.betaseries.com/fonds/seasons/10051/62088692.jpg",
                    "interval": "1 - 10"
                },
                {
                    "number": 2,
                    "episodes": 12,
                    "image": "https://pictures.betaseries.com/fonds/seasons/10051/62088690.jpg",
                    "interval": "11 - 22"
                },
                {
                    "number": 3,
                    "episodes": 10,
                    "image": "https://pictures.betaseries.com/fonds/seasons/10051/62088688.jpg",
                    "interval": "23 - 32"
                },
                {
                    "number": 4,
                    "episodes": 13,
                    "image": "https://pictures.betaseries.com/fonds/seasons/10051/62088675.jpg",
                    "interval": "33 - 45"
                }
            ],
            "time": 7700,
            "episodes": 154
        }
        """
        
        let jsonData = try XCTUnwrap(jsonSerieInfos.data(using: .utf8))
        let infos = try decoder.decode(SerieInfos.self, from: jsonData)
        XCTAssertEqual(infos.seasons.count, 4)
        XCTAssertEqual(infos.time, 7700)
        XCTAssertEqual(infos.episodes, 154)
    }
}
