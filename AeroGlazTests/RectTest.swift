//
//  RectTest.swift
//  AeroGlazTests
//
//  Created by Evgeny Agamirzov on 25.06.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import XCTest
@testable import AeroGlaz

class RectTest: XCTestCase {
    func testRectContainsPoint() {
        let rect = Rect(CGPoint(x: 0, y: 0), CGPoint(x: 2, y: 1))

        // Trivial case point inside
        XCTAssertTrue(rect.contains(CGPoint(x: 1, y: 1)))

        // Trivial case point outside
        XCTAssertFalse(rect.contains(CGPoint(x: 3, y: 2)))

        // Edge case minimum point
        XCTAssertTrue(rect.contains(CGPoint(x: 0, y: 1)))

        // Edge case maximum point
        XCTAssertTrue(rect.contains(CGPoint(x: 2, y: 0.5)))
    }
}
