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
        // Trivial case
        var rect = Span(CGPoint(x: 0, y: 0), CGPoint(x: 2, y: 1))
        XCTAssertTrue(rect.contains(CGPoint(x: 1, y: 1)))
        XCTAssertFalse(rect.contains(CGPoint(x: 3, y: 2)))
        XCTAssertTrue(rect.contains(CGPoint(x: 0, y: 1)))
        XCTAssertTrue(rect.contains(CGPoint(x: 2, y: 0.5)))

        // Edge case rect with no width
        rect = Span(CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 1))
        XCTAssertTrue(rect.contains(CGPoint(x: 0, y: 0)))
        XCTAssertTrue(rect.contains(CGPoint(x: 0, y: 0.3)))
        XCTAssertTrue(rect.contains(CGPoint(x: 0, y: 1)))
        XCTAssertFalse(rect.contains(CGPoint(x: 0, y: 1.1)))
    }

    func testRectCenterPoint() {
        // Trivial case
        var rect = Span(CGPoint(x: 0, y: 0), CGPoint(x: 2, y: 1))
        XCTAssertEqual(rect.center, CGPoint(x: 1, y: 0.5))

        // Edge case rect with no width
        rect = Span(CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 1))
        XCTAssertEqual(rect.center, CGPoint(x: 0, y: 0.5))
    }
}
