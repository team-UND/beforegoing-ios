//
//  UIFontExtensionTest.swift
//  BeforeGoing
//
//  Created by APPLE on 8/8/25.
//

import XCTest
@testable import BeforeGoing

final class UIFontExtensionTest: XCTestCase {
    
    func testCustomFontCreation() {
        let font = UIFont.custom(.headingH1)
        XCTAssertNotNil(font)
        XCTAssertEqual(font.pointSize, UIFont.CustomFont.headingH1.size)
    }
}
