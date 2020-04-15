//
//  BackgrounderUITests.swift
//  BackgrounderUITests
//
//  Created by Alex Agapov on 15.04.2020.
//  Copyright © 2020 Alex Agapov. All rights reserved.
//

import XCTest

class BackgrounderUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    func testExample() throws {
        snapshot("0Launch")
    }

//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
