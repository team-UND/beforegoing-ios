//
//  StringExtensionTest.swift
//  BeforeGoing
//
//  Created by APPLE on 8/8/25.
//

import XCTest
@testable import BeforeGoing

final class StringExtensionTest: XCTestCase {
    
    func testIsValidNickname() {
        let nicknames = ["가", "가나다라마바사아", "1", "12345678", "a", "abcdefgh", "가1", "가a", "1a"]
        nicknames.forEach {
            XCTAssertTrue($0.isValidNickname)
        }
    }
    
    func testIsInvalidNickname() {
        let nicknames = ["", "123456789", "$", "가나다라 마바사"]
        nicknames.forEach {
            XCTAssertFalse($0.isValidNickname)
        }
    }
    
    func testTrim() {
        let name = "beforegoing"
        let trimmedName = name.trim(limit: 6)
        XCTAssertEqual(trimmedName, "before")
    }
}
