//
//  HelperTest.swift
//  anothapp
//
//  Created by Adrien Garrouste on 20/06/2025.
//

import XCTest
@testable import anothapp

class HelperTest: XCTestCase {
    
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
    
    func testIsValidUsername() {
        XCTAssertFalse(Helper.shared.isValidUsername("te"))
        XCTAssertFalse(Helper.shared.isValidUsername(""))
        XCTAssertFalse(Helper.shared.isValidUsername("test12345678901234567890123456789012"))
        XCTAssertTrue(Helper.shared.isValidUsername("thisUsernameIsValid"))
    }
    
    func testIsValidPassword() {
        XCTAssertFalse(Helper.shared.isValidPassword("te"))
        XCTAssertFalse(Helper.shared.isValidPassword(""))
        XCTAssertFalse(Helper.shared.isValidPassword(String(repeating: "a", count: 100)))
        XCTAssertTrue(Helper.shared.isValidPassword("test123456"))
    }
    
    func testIsValidEmail() {
        XCTAssertFalse(Helper.shared.isValidEmail("test"))
        XCTAssertFalse(Helper.shared.isValidEmail(""))
        XCTAssertTrue(Helper.shared.isValidEmail("test@test.com"))
        XCTAssertFalse(Helper.shared.isValidEmail("test123@test."))
    }
    
    func testFormatMins() {
        XCTAssertEqual(Helper.shared.formatMins(-1), "0 min")
        XCTAssertEqual(Helper.shared.formatMins(120), "2 heures")
        XCTAssertEqual(Helper.shared.formatMins(0), "0 min")
        XCTAssertEqual(Helper.shared.formatMins(395328), "274 jours 12 heures 48 mins")
    }
}
