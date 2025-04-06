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
    
    func testStringFormattingError() {
        XCTAssertThrowsError(try Helper.shared.stringToDate(str: ""))
    }
    
    
    func testDateFormatting() {
        XCTAssertNoThrow(try Helper.shared.stringToDate(str: "2024-10-10T17:56:24.228Z"))
    }
    
    func testDateToString() {
        let string = Helper.shared.dateToString(date: Date())
        XCTAssertNotEqual(string, "")
    }
    
    func testCompareDate() throws {
        let first = try Helper.shared.stringToDate(str: "2024-10-10T17:56:24.228Z")
        let second = try Helper.shared.stringToDate(str: "2025-02-12T13:12:58.024Z")
        XCTAssertTrue(first < second)
    }
    
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
            "seasons": 2
        }
        """
        
        let serie = try? decoder.decode(Serie.self, from: jsonSerie.data(using: .utf8)!)
        XCTAssertNotNil(serie)
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
        
        let infos = try? decoder.decode(SerieInfos.self, from: jsonSerieInfos.data(using: .utf8)!)
        XCTAssertNotNil(infos)
    }
}
