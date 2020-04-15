//
//  UITests.swift
//  UITests
//
//  Created by Alex Agapov on 15.04.2020.
//  Copyright © 2020 Alex Agapov. All rights reserved.
//

import XCTest

class UITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false

        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    func testExample() throws {
        snapshot("0Launch")
    }
}
