//
//  ActionHierarchyUITests.swift
//  ActionHierarchyUITests
//
//  Created by Emilio Peláez on 6/1/22.
//

import XCTest

class ActionHierarchyUITests: XCTestCase {
	
	override func setUpWithError() throws {
		continueAfterFailure = false
	}
	
	override func tearDownWithError() throws {
	}
	
	func testExample() throws {
		let app = XCUIApplication()
		app.launch()
		
		app.buttons["Test 1"].tap()
		
		XCTAssert(app.alerts["Test 1"].exists)
		
		app.buttons["Close"].tap()
		
		app.buttons["Test 2"].tap()
		
		XCTAssert(app.alerts["Test 2"].exists)
	}
}
