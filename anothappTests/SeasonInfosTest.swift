//
//  SeasonInfosTest.swift
//  anothapp
//
//  Created by Adrien Garrouste on 03/04/2025.
//

import XCTest
@testable import anothapp

class SeasonInfosTest: XCTestCase {
    
    private let decoder = JSONDecoder()
    
    func testDeserializeEpisode() throws {
        let jsonSeasonDetails = """
        [
            {
                "id": 1399,
                "addedAt": "2018-04-01T20:00:00.000Z",
                "platform": {
                    "id": 1,
                    "name": "Netflix",
                    "logo": "https://pictures.betaseries.com/platforms/1.jpg"
                }
            }
        ]
        """
        
        let jsonData = try XCTUnwrap(jsonSeasonDetails.data(using: .utf8))
        let infos = try decoder.decode([SeasonInfos].self, from: jsonData)
        XCTAssertNotNil(infos)
        XCTAssertTrue(infos.count == 1)
        XCTAssertEqual(infos[0].id, 1399)
        
        let date = try Helper.shared.stringToDate(str: "2018-04-01T20:00:00.000Z")
        XCTAssertEqual(infos[0].addedAt, date)
        XCTAssertEqual(infos[0].platform.id, 1)
        XCTAssertEqual(infos[0].platform.name, "Netflix")
    }
}
