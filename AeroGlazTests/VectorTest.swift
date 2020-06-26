//
//  VectorTest.swift
//  AeroGlazTests
//
//  Created by Evgeny Agamirzov on 256.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import XCTest
@testable import AeroGlaz

class VectorTest: XCTestCase {
    let eps = CGFloat(10e-6)

    func testVectorsAngleCaculation() {
        // Trivial case
        var v = Vector(CGPoint(x: 0, y: 0), CGPoint(x: 2, y: 2))
        var u = Vector(CGPoint(x: 0, y: 0), CGPoint(x: 3, y: 0))
        XCTAssertEqual(v.norm, sqrt(8))
        XCTAssertEqual(u.norm, sqrt(9))
        XCTAssertEqual(v.dot(u), 6)
        XCTAssertEqual(v.theta(u), CGFloat.pi / 4, accuracy: eps)

        // Edge case, parallel vectors
        v = Vector(CGPoint(x: 0, y: 0), CGPoint(x: 2, y: 0))
        u = Vector(CGPoint(x: 0, y: 0), CGPoint(x: 3, y: 0))
        XCTAssertEqual(v.norm, sqrt(4))
        XCTAssertEqual(u.norm, sqrt(9))
        XCTAssertEqual(v.dot(u), 6)
        XCTAssertEqual(v.theta(u), 0, accuracy: eps)

        // Edge case, anti-parallel vectors
        v = Vector(CGPoint(x: 0, y: 0), CGPoint(x: 2, y: 2))
        u = Vector(CGPoint(x: 0, y: 0), CGPoint(x: -2, y: -2))
        XCTAssertEqual(v.norm, sqrt(8))
        XCTAssertEqual(u.norm, sqrt(8))
        XCTAssertEqual(v.dot(u), -8)
        XCTAssertEqual(v.theta(u), CGFloat.pi, accuracy: eps)
    }

    func testVectorsContainsPoint() {
        // Trivial case
        var v = Vector(CGPoint(x: 0, y: 0), CGPoint(x: 2, y: 2))
        XCTAssertTrue(v.contains(CGPoint(x: 0, y: 0)))
        XCTAssertTrue(v.contains(CGPoint(x: 1, y: 1)))
        XCTAssertFalse(v.contains(CGPoint(x: 0, y: 2)))
        XCTAssertFalse(v.contains(CGPoint(x: 3, y: 3)))

        // Edge case vertical line
        v = Vector(endPoint: CGPoint(x: 0, y: 1))
        XCTAssertTrue(v.contains(CGPoint(x: 0, y: 0)))
        XCTAssertTrue(v.contains(CGPoint(x: 0, y: 0.5)))
        XCTAssertFalse(v.contains(CGPoint(x: 1, y: 1)))
        XCTAssertFalse(v.contains(CGPoint(x: -1, y: 0)))
    }

    func testVectorLineIntersection() {
        // Trivial case intersection within vector span
        var line = Line(a: sqrt(2), b: 0)
        var vector = Vector(CGPoint(x: 0, y: 1), CGPoint(x: 2, y: 2))
        var point = vector.intersectionPoint(with: line)
        XCTAssertFalse(point == nil)
        XCTAssertTrue(vector.contains(point!))

        // Trivial case intersection beyond vector span
        line = Line(a: sqrt(2), b: 0)
        vector = Vector(CGPoint(x: 0, y: 1), CGPoint(x: 2, y: 3))
        point = vector.intersectionPoint(with: line)
        XCTAssertTrue(point == nil)

        // Edge case line overlap
        line = Line(a: 1, b: 0)
        vector = Vector(CGPoint(x: 0, y: 0), CGPoint(x: 2, y: 2))
        point = vector.intersectionPoint(with: line)
        XCTAssertFalse(point == nil)
        XCTAssertEqual(point!, CGPoint(x: 1, y: 1))
    }
}
