//
//  UtilsTest.swift
//  BackgrounderTests
//
//  Created by Alex Agapov on 11/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import XCTest
@testable import Backgrounder

class UtilsTest: XCTestCase {

    var width: CGFloat = 0
    var padding: CGFloat = 0
    var items: CGFloat = 0
    
    var expected: CGFloat = 0
    
    func test2Items() {
        width = 60
        padding = 8
        items = 2
        
        expected = 10
        
        let result = countLayout(width: width, padding: padding, itemsPerRow: items)
        
        XCTAssertEqual(result, expected, "Should count layout one item for a grid")
    }
    
    func test3Items() {
        width = 336
        padding = 8
        items = 3

        expected = 96

        let result = countLayout(width: width, padding: padding, itemsPerRow: items)

        XCTAssertEqual(result, expected, "Should count layout one item for a grid")
    }

    func test4Items() {
        width = 88
        padding = 8
        items = 4
        
        expected = 8
        
        let result = countLayout(width: width, padding: padding, itemsPerRow: items)
        
        XCTAssertEqual(result, expected, "Should count layout one item for a grid")
    }
}
