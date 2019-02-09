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

    typealias Input = (width: CGFloat, padding: CGFloat, items: CGFloat)
    var inputs = [Input]()

    var expected = [CGFloat]()

    func testSinglePaddingItems() {
        inputs = [
            (36, 8, 1),
            (64, 8, 2),
            (92, 8, 3),
            (120, 8, 4)
        ]

        expected = [
            20,
            20,
            20,
            20
        ]

        inputs.enumerated().forEach { offset, input in
            let result = countSinglePaddingLayout(width: input.width,
                                                  padding: input.padding,
                                                  itemsPerRow: input.items)

            XCTAssertEqual(result, expected[offset], "Should count layout one item for a grid")
        }
    }

    func testDoublePaddingItems() {
        inputs = [
            (60, 8, 1),
            (60, 8, 2),
            (336, 8, 3),
            (88, 8, 4)
        ]

        expected = [
            28,
            10,
            96,
            8
        ]

        inputs.enumerated().forEach { offset, input in
            let result = countDoublePaddingLayout(width: input.width,
                                                  padding: input.padding,
                                                  itemsPerRow: input.items)

            XCTAssertEqual(result, expected[offset], "Should count layout one item for a grid")
        }
    }
}
