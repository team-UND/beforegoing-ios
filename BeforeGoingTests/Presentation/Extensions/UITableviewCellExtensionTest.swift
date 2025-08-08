//
//  UITableviewCellExtensionTest.swift
//  BeforeGoing
//
//  Created by APPLE on 8/8/25.
//

import XCTest
@testable import BeforeGoing

final class UITableviewCellExtensionTest: XCTestCase {
    
    func testReuseIdentifier() {
        let reuseIdentifier = AgreeItemCell.identifier
        XCTAssertEqual(reuseIdentifier, "AgreeItemCell")
    }
}
