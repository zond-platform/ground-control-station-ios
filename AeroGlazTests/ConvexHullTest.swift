//
//  GeometryTests.swift
//  GeometryTests
//
//  Created by Evgeny Agamirzov on 27/10/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import XCTest
@testable import AeroGlaz

class ConvexHullTest: XCTestCase {
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
            CGPoint(x: 1, y: 1),
            CGPoint(x: 2, y: 1),
            CGPoint(x: 1, y: 0),
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 1),
        ]
        measure {
            let hull = ConvexHull()
            hull.compute(points)
            XCTAssertTrue(hull.isValid)
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
            CGPoint(x: 0, y: 2),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 0, y: 0),
        ]
        var hull = ConvexHull()
        hull.compute(points)
        XCTAssertTrue(hull.isValid)
        XCTAssertEqual(hull.points, expected)

        // Edge case less than three points is illegal
        points = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 1)
        ]
        expected = [
            CGPoint(x: 0, y: 1),
            CGPoint(x: 0, y: 0)
        ]
        hull = ConvexHull()
        hull.compute(points)
        XCTAssertFalse(hull.isValid)
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
        let hull = ConvexHull()
        hull.compute(points)
        XCTAssertTrue(hull.isValid)
        
        // Trivial case
        var line = Line(a: 0.25, b: 0)
        var intersectionPoints = hull.intersections(with: line)
        XCTAssertEqual(intersectionPoints.count, 2)
        XCTAssertEqual(intersectionPoints[0], CGPoint(x: 2, y: 0.5))
        XCTAssertEqual(intersectionPoints[1], CGPoint(x: -2, y: -0.5))

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

    func test() {
        let points = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 1, y: 0),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 1, y: 1),
        ]
        let hull = ConvexHull()
        hull.compute(points)
        XCTAssertTrue(hull.isValid)

        // Edge case lines from vertices
        measure {
            for point in hull.points {
                let line = Line(tangent: 1, point: point)
                let intersectionPoints = hull.intersections(with: line)
                XCTAssertNotEqual(intersectionPoints.count, 0)
            }
        }
    }

    func testConvexHullPointsBelongOneEdge() {
        let points = [
            CGPoint(x: 0, y: 2),
            CGPoint(x: -1, y: 2),
            CGPoint(x: -2, y: 1),
            CGPoint(x: -2, y: -1),
            CGPoint(x: 0, y: -2),
            CGPoint(x: 2, y: -1),
            CGPoint(x: 2, y: 1),
        ]
        let hull = ConvexHull()
        hull.compute(points)
        XCTAssertTrue(hull.isValid)

        // Trivial case one edge
        XCTAssertTrue(hull.pointsBelongOneEdge(points[0], points[1]))
        XCTAssertTrue(hull.pointsBelongOneEdge(points[1], points[0]))
        XCTAssertTrue(hull.pointsBelongOneEdge(points[3], points[4]))
        XCTAssertTrue(hull.pointsBelongOneEdge(points[2], points[3]))

        // Trivial case different edges
        XCTAssertFalse(hull.pointsBelongOneEdge(points[0], points[2]))

        // Edge case same point
        XCTAssertFalse(hull.pointsBelongOneEdge(points[0], points[0]))
    }
}
