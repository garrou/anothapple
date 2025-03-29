//
//  SerieTest.swift
//  anothapp
//
//  Created by Adrien Garrouste on 29/03/2025.
//

import XCTest
@testable import anothapp

class SerieTest: XCTestCase {
    
    func testDateFormatting() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        XCTAssertNotNil(formatter.date(from: "2024-10-10T17:56:24.228Z"))
    }
    
    func testCompareDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let first = formatter.date(from: "2024-10-10T17:56:24.228Z")
        let second = formatter.date(from: "2025-02-12T13:12:58.024Z")
        XCTAssertTrue(first! < second!)
    }
    
    func testDeserialize() async throws {
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
        
        let decoder = JSONDecoder()
        let serie = try decoder.decode(Serie.self, from: jsonSerie.data(using: .utf8)!)
        XCTAssertNotNil(serie)
    }
}
