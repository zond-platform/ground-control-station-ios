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

    func testVectorLineIntersection() {
        // Trivial case intersection within vector span
        var line = Line(a: sqrt(2), b: 0)
        var vector = Vector(CGPoint(x: 0, y: 1), CGPoint(x: 2, y: 2))
        var point = vector.intersectionPoint(with: line)
        XCTAssertEqual(point.count, 1)

        // Trivial case intersection beyond vector span
        line = Line(a: sqrt(2), b: 0)
        vector = Vector(CGPoint(x: 0, y: 1), CGPoint(x: 2, y: 3))
        point = vector.intersectionPoint(with: line)
        XCTAssertEqual(point.count, 0)

        // Edge case line overlap
        line = Line(a: 1, b: 0)
        vector = Vector(CGPoint(x: 0, y: 0), CGPoint(x: 2, y: 2))
        point = vector.intersectionPoint(with: line)
        XCTAssertEqual(point.count, 2)
        XCTAssertEqual(point[0], CGPoint(x: 0, y: 0))
        XCTAssertEqual(point[1], CGPoint(x: 2, y: 2))

        // Edge case line touches vector point
        line = Line(tangent: 2, point: CGPoint(x: -1, y: 2))
        vector = Vector(CGPoint(x: -2, y: 1), CGPoint(x: -1, y: 2))
        point = vector.intersectionPoint(with: line)
        XCTAssertEqual(point.count, 1)
        XCTAssertEqual(point[0], CGPoint(x: -1, y: 2))
    }
}
