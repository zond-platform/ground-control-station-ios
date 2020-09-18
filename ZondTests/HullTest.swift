//
//  GeometryTests.swift
//  GeometryTests
//
//  Created by Evgeny Agamirzov on 27/10/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import XCTest
@testable import Zond

class ConvexHullTest : XCTestCase {
    func testConvexHullCreation() {
        // Trivial case
        var points = [
            CGPoint(x: 2, y: 1),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0.5, y: 0.5),
            CGPoint(x: 1, y: 0),
        ]
        var expected = [
            CGPoint(x: 0, y: 1),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 2, y: 1),
            CGPoint(x: 1, y: 0),
            CGPoint(x: 0, y: 0),
        ]
        measure {
            let hull = Hull()
            hull.compute(points)
            XCTAssertEqual(hull.points, expected)
        }

        // Edge case points on one line are legal
        points = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 0, y: 2),
        ]
        expected = [
            CGPoint(x: 0, y: 1),
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 0, y: 2),
        ]
        var hull = Hull()
        hull.compute(points)
        XCTAssertEqual(hull.points, expected)

        // Edge case less than three points is illegal
        points = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 1)
        ]
        expected = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 1)
        ]
        hull = Hull()
        hull.compute(points)
        XCTAssertEqual(hull.points, expected)

        // One point
        points = [
            CGPoint(x: 23, y: -6)
        ]
        expected = [
            CGPoint(x: 23, y: -6)
        ]
        hull = Hull()
        hull.compute(points)
        XCTAssertEqual(hull.points, expected)
    }

    func testConvexHullLineIntersection() {
        let points = [
            CGPoint(x: 0, y: 2),
            CGPoint(x: -1, y: 2),
            CGPoint(x: -2, y: 1),
            CGPoint(x: -2, y: -1),
            CGPoint(x: 0, y: -2),
            CGPoint(x: 2, y: -1),
            CGPoint(x: 2, y: 1),
        ]
        let hull = Hull()
        hull.compute(points)
        
        // Trivial case
        var line = Line(a: 0.25, b: 0)
        var intersectionPoints = hull.intersections(with: line)
        XCTAssertEqual(intersectionPoints.count, 2)
        XCTAssertEqual(intersectionPoints[0], CGPoint(x: -2, y: -0.5))
        XCTAssertEqual(intersectionPoints[1], CGPoint(x: 2, y: 0.5))

        // Edge case vertex intersection
        line = Line(a: -1, b: 3)
        intersectionPoints = hull.intersections(with: line)
        XCTAssertEqual(intersectionPoints.count, 1)
        XCTAssertEqual(intersectionPoints[0], CGPoint(x: 2, y: 1))

        // Edge case overlap with one edge
        line = Line(a: 0.5, b: -2)
        intersectionPoints = hull.intersections(with: line)
        XCTAssertEqual(intersectionPoints.count, 2)
        XCTAssertEqual(intersectionPoints[0], CGPoint(x: 2, y: -1))
        XCTAssertEqual(intersectionPoints[1], CGPoint(x: 0, y: -2))
    }
}
