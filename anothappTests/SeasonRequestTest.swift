//
//  SeasonRequestTest.swift
//  anothapp
//
//  Created by Adrien Garrouste on 20/06/2025.
//

import XCTest
@testable import anothapp

class SeasonRequestTest: XCTestCase {
    
    private let decoder = JSONDecoder()
    
    func testSerializeUpdateSeason() throws {
        let date = try Helper.shared.stringToDate(str: "2025-06-20", format: "yyyy-MM-dd")
        let episodeInfos: UpdateSeasonRequest = .init(id: 1905, platform: 1, viewedAt: date)
        let jsonData = try JSONEncoder().encode(episodeInfos)
        XCTAssertNotNil(jsonData)
    }
}
