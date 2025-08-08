//
//  Adjust+Test.swift
//  BeforeGoing
//
//  Created by APPLE on 8/8/25.
//

import XCTest
@testable import BeforeGoing

final class AdjustExtensionTest: XCTestCase {
    
    func testCGFloatAdjustedW() {
        let original: CGFloat = 100
        let screenWidth = UIScreen.main.bounds.width
        let expected = original * (screenWidth / 375)

        let adjusted = original.adjustedW

        XCTAssertEqual(adjusted, expected, accuracy: 0.001)
    }
    
    func testDoubleAdjustedW() {
        let original: Double = 100
        let screenWidth = UIScreen.main.bounds.width
        let expected = original * (screenWidth / 375)

        let adjusted = original.adjustedW

        XCTAssertEqual(adjusted, expected, accuracy: 0.001)
    }
    
    func testIntAdjustedW() {
        let original: Int = 375
        let expected = UIScreen.main.bounds.width

        let adjusted = original.adjustedW

        XCTAssertEqual(adjusted, expected, accuracy: 0.001)
    }
    
    func testCGFloatAdjustedH() {
        let original: CGFloat = 100
        let screenHeight = UIScreen.main.bounds.height
        let expected = original * (screenHeight / 812)

        let adjusted = original.adjustedH

        XCTAssertEqual(adjusted, expected, accuracy: 0.001)
    }
    
    func testDoubleAdjustedH() {
        let original: Double = 100
        let screenHeight = UIScreen.main.bounds.height
        let expected = original * (screenHeight / 812)

        let adjusted = original.adjustedH

        XCTAssertEqual(adjusted, expected, accuracy: 0.001)
    }
    
    func testIntAdjustedH() {
        let original: Int = 812
        let expected = UIScreen.main.bounds.height

        let adjusted = original.adjustedH

        XCTAssertEqual(adjusted, expected, accuracy: 0.001)
    }
}
