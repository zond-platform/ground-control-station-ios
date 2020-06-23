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
    func testLineCreation() {
        // Trivial case
        var line = Line(a: 1, b: 2)
        XCTAssertEqual(line.a!, 1)
        XCTAssertEqual(line.b!, 2)
        XCTAssertTrue(line.x == nil)

        // Line from angle and point
        line = Line(angle: GeometryUtils.pi / 3 , point: CGPoint(x: 3, y: 4))
        XCTAssertEqual(line.a!, sqrt(3), accuracy: GeometryUtils.eps)
        XCTAssertEqual(line.b!, 4 - 3 * sqrt(3), accuracy: GeometryUtils.eps)
        XCTAssertTrue(line.x == nil)

        // Vertical line from angle and point
        line = Line(x: 3)
        XCTAssertTrue(line.a == nil)
        XCTAssertTrue(line.b == nil)
        XCTAssertEqual(line.x!, 3)

        // Line from vertical vector
        var v = Vector(CGPoint(x: 0.0, y: 1.0), CGPoint(x: 2.0, y: 3.0))
        line = Line(vector: v)
        XCTAssertEqual(line.a!, 1)
        XCTAssertEqual(line.b!, 1)
        XCTAssertTrue(line.x == nil)

        // Vertical line from vertical vector
        v = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 2.0))
        line = Line(vector: v)
        XCTAssertTrue(line.a == nil)
        XCTAssertTrue(line.b == nil)
        XCTAssertEqual(line.x!, 0)
    }

    func testVectorIntersection() {
        // Trivial case
        var l1 = Line(a: 1, b: 0)
        var l2 = Line(a: -1, b: 2)
        var result = l1.intersectionPoint(with: l2)
        XCTAssertEqual(try result.get(), CGPoint(x: 1, y: 1))

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
}
