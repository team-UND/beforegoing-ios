//
//  AgreeItemViewModelTest.swift
//  BeforeGoing
//
//  Created by APPLE on 8/8/25.
//

import XCTest
@testable import BeforeGoing

final class AgreeItemViewModelTest: XCTestCase {
    
    private var viewModel: AgreeItemViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = AgreeItemViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testCreateViewModel() {
        AgreeItem.allCases.forEach {
            XCTAssertEqual(viewModel.getState(item: $0), .unchecked)
        }
    }
    
    func testToggleItem() {
        let agreeItem: AgreeItem = .isPushAgreed
        viewModel?.toggleItem(item: agreeItem, checkBoxState: .checked)
        XCTAssertEqual(viewModel.getState(item: agreeItem), .checked)
    }
    
    func testToggleAllItem() {
        viewModel?.toggleAllItems(checkBoxState: .checked)
        AgreeItem.allCases.forEach {
            XCTAssertEqual(viewModel.getState(item: $0), .checked)
        }
    }
    
    func testIsAllChecked() {
        viewModel?.toggleAllItems(checkBoxState: .checked)
        XCTAssertTrue(viewModel.isAllChecked)
    }
    
    func testIsAllNecessaryChecked() {
        AgreeItem.allCases.forEach {
            if $0.component.isNecessary {
                viewModel.toggleItem(item: $0, checkBoxState: .checked)
            }
        }
        XCTAssertTrue(viewModel.isAllNecssaryChecked)
    }
}
