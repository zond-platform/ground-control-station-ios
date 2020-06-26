//
//  LineTest.swift
//  AeroGlazTests
//
//  Created by Evgeny Agamirzov on 23.06.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import XCTest
@testable import AeroGlaz

class LineTest: XCTestCase {
    let eps = CGFloat(10e-6)

    func testLineCreation() {
        // Trivial case
        var line = Line(a: 1, b: 2)
        XCTAssertEqual(line.a!, 1)
        XCTAssertEqual(line.b!, 2)
        XCTAssertTrue(line.x == nil)

        // Line from angle and point
        line = Line(angle: CGFloat.pi / 3 , point: CGPoint(x: 3, y: 4))
        XCTAssertEqual(line.a!, sqrt(3), accuracy: eps)
        XCTAssertEqual(line.b!, 4 - 3 * sqrt(3), accuracy: eps)
        XCTAssertTrue(line.x == nil)

        // Edge case vertical line from angle and point
        line = Line(angle: 3 * CGFloat.pi / 2 , point: CGPoint(x: 3, y: 4))
        XCTAssertTrue(line.a == nil)
        XCTAssertTrue(line.b == nil)
        XCTAssertEqual(line.x!, 3)

        // Edge case vertical line
        line = Line(x: 3)
        XCTAssertTrue(line.a == nil)
        XCTAssertTrue(line.b == nil)
        XCTAssertEqual(line.x!, 3)
    }

    func testLineIntersection() {
        // Trivial case
        var l1 = Line(a: 1, b: 0)
        var l2 = Line(a: -1, b: 2)
        var result = l1.intersectionPoint(with: l2)
        XCTAssertEqual(try result.get(), CGPoint(x: 1, y: 1))

        // Trivial case irrational numbers
        l1 = Line(a: sqrt(2), b: 0)
        l2 = Line(a: -1, b: 2)
        result = l1.intersectionPoint(with: l2)
        XCTAssertEqual(try result.get(), CGPoint(x: 2 / (sqrt(2) + 1), y: 2 * sqrt(2) / (sqrt(2) + 1)))

        // Edge case with vectors touching common point
        l1 = Line(a: 1, b: 0)
        l2 = Line(a: -1, b: 4)
        result = l1.intersectionPoint(with: l2)
        XCTAssertEqual(try result.get(), CGPoint(x: 2, y: 2))

        // Edge case l1 is vertical
        l1 = Line(x: 0)
        l2 = Line(a: -1, b: 1)
        result = l1.intersectionPoint(with: l2)
        XCTAssertEqual(try result.get(), CGPoint(x: 0, y: 1))

        // Edge case l2 is vertical
        l1 = Line(a: 1, b: 0)
        l2 = Line(x: 1)
        result = l1.intersectionPoint(with: l2)
        XCTAssertEqual(try result.get(), CGPoint(x: 1, y: 1))
        
        // Edge case l1 and l2 are vertical and parallel
        l1 = Line(x: 0)
        l2 = Line(x: 1)
        result = l1.intersectionPoint(with: l2)
        XCTAssertThrowsError(try result.get()) {
            XCTAssertEqual($0 as! IntersectionError, .parallel)
        }

        // Edge case l1 and l2 are vertical and overlapping
        l1 = Line(x: 1)
        l2 = Line(x: 1)
        result = l1.intersectionPoint(with: l2)
        XCTAssertThrowsError(try result.get()) {
            XCTAssertEqual($0 as! IntersectionError, .overlap)
        }

        // Edge case l1 and l2 are orthogonal
        l1 = Line(a: 0, b: 2)
        l2 = Line(x: 1)
        result = l1.intersectionPoint(with: l2)
        XCTAssertEqual(try result.get(), CGPoint(x: 1, y: 2))

        // Edge case l1 and l2 are parallel
        l1 = Line(a: 2, b: 3)
        l2 = Line(a: 2, b: 4)
        result = l1.intersectionPoint(with: l2)
        XCTAssertThrowsError(try result.get()) {
            XCTAssertEqual($0 as! IntersectionError, .parallel)
        }

        // Edge case l1 and l2 are parallel and overlapping
        l1 = Line(a: 2, b: 3)
        l2 = Line(a: 2, b: 3)
        result = l1.intersectionPoint(with: l2)
        XCTAssertThrowsError(try result.get()) {
            XCTAssertEqual($0 as! IntersectionError, .overlap)
        }
    }

    func testLineMovement() {
        // Trivial case moving down positive tangent
        var line = Line(a: 1, b: 2)
        line.move(for: -(2 * sqrt(2)))
        XCTAssertEqual(line.a!, 1)
        XCTAssertEqual(line.b!, -2, accuracy: eps)
        XCTAssertTrue(line.x == nil)

        // Trivial case moving up positive tangent
        line = Line(a: 1, b: 2)
        line.move(for: sqrt(2))
        XCTAssertEqual(line.a!, 1)
        XCTAssertEqual(line.b!, 4, accuracy: eps)
        XCTAssertTrue(line.x == nil)

        // Trivial case moving down negative tangent
        line = Line(a: -1, b: 2)
        line.move(for: -(2 * sqrt(2)))
        XCTAssertEqual(line.a!, -1)
        XCTAssertEqual(line.b!, -2, accuracy: eps)
        XCTAssertTrue(line.x == nil)

        // Trivial case moving up negative tangent
        line = Line(a: -1, b: 2)
        line.move(for: sqrt(2))
        XCTAssertEqual(line.a!, -1)
        XCTAssertEqual(line.b!, 4, accuracy: eps)
        XCTAssertTrue(line.x == nil)

        // Edge case moving vertical line left
        line = Line(x: 1)
        line.move(for: -2)
        XCTAssertTrue(line.a == nil)
        XCTAssertTrue(line.b == nil)
        XCTAssertEqual(line.x!, -1)

        // Edge case moving vertical line up
        line = Line(x: 1)
        line.move(for: 3)
        XCTAssertTrue(line.a == nil)
        XCTAssertTrue(line.b == nil)
        XCTAssertEqual(line.x!, 4)
    }

    func testLineContainsPoint() {
        // Trivial case
        var line = Line(a: 1, b: 2)
        XCTAssertTrue(line.contains(CGPoint(x: 2, y: 4)))
        XCTAssertFalse(line.contains(CGPoint(x: 3, y: 4)))

        // Edge case vertical line
        line = Line(x: 3)
        XCTAssertTrue(line.contains(CGPoint(x: 3, y: 0)))
        XCTAssertTrue(line.contains(CGPoint(x: 3, y: 10)))
        XCTAssertFalse(line.contains(CGPoint(x: 2, y: 3)))
    }
}
