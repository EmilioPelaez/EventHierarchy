//
//  EventHierarchyUITests.swift
//  EventHierarchyUITests
//
//  Created by Emilio Peláez on 8/1/22.
//

import XCTest

class EventHierarchyUITests: XCTestCase {
	
	override func setUpWithError() throws {
		continueAfterFailure = false
	}
	
	override func tearDownWithError() throws {}
	
	func testExample() throws {
		let app = XCUIApplication()
		app.launch()
		
		app.buttons["Event Test 0"].tap()
		
		XCTAssert(true)
		
		app.buttons["Event Test 1"].tap()
		
		XCTAssert(app.alerts["Event Test 1"].exists)
		
		app.buttons["Close"].tap()
		
		app.buttons["Event Test 2"].tap()
		
		XCTAssert(app.alerts["Event Test 2"].exists)
		
		app.buttons["Close"].tap()
		
		app.buttons["Event Test 4"].tap()
		
		XCTAssert(app.alerts["Event Test 4"].exists)
		
		app.buttons["Close"].tap()
		
		app.buttons["Event Test 5"].tap()
		
		XCTAssert(app.alerts["Event Test 5"].exists)
		
		app.buttons["Close"].tap()
		
		app.buttons["Event Test 6"].tap()
		
		XCTAssert(app.alerts["Event Test 6"].exists)
	}
}
