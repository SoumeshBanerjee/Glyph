//
//  GlyphUITests.swift
//  GlyphUITests
//
//  Created by Soumesh Banerjee on 16/10/18.
//  Copyright © 2018 Soumesh Banerjee. All rights reserved.
//

import XCTest

class GlyphUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = true
        
        let app = XCUIApplication()
        app.launch()
        
        let FlickerSearchKeywordText = app.searchFields["Search"]
        FlickerSearchKeywordText.tap()
        
        app.keys["A"].tap()
        app.keys["p"].tap()
        app.keys["p"].tap()
        app.keys["l"].tap()
        app.keys["e"].tap()
        app.buttons["Search"].tap()
        
    }

    override func tearDown() {
    }

    func testSearch() {
        let app = XCUIApplication()
        let collectionViewsQuery = app.collectionViews
        let exists = NSPredicate(format: "count >= 10")
        wait(for: [expectation(for: exists, evaluatedWith: collectionViewsQuery.cells, handler: nil)], timeout: 20)
    }
    
    func testScrolling() {
        let app = XCUIApplication()
        let collectionViewsQuery = app.collectionViews
        let exists = NSPredicate(format: "count >= 10")
        wait(for: [expectation(for: exists, evaluatedWith: collectionViewsQuery.cells, handler: nil)], timeout: 20)
        
        collectionViewsQuery.children(matching: .cell).element(boundBy: 10).children(matching: .other).element.swipeUp()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 20).children(matching: .other).element.swipeUp()
        
        collectionViewsQuery.children(matching: .cell).element(boundBy: 15).children(matching: .other).element.swipeDown()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 7).children(matching: .other).element.swipeDown()
        
        
    }

}
