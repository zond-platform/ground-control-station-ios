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
    func testConvexHull() {
        // Trivial case
        var points = [
            CGPoint(x: 2.0, y: 1.0),
            CGPoint(x: 1.0, y: 1.0),
            CGPoint(x: 0.0, y: 1.0),
            CGPoint(x: 0.0, y: 0.0),
            CGPoint(x: 0.5, y: 0.5),
            CGPoint(x: 1.0, y: 0.0),
        ]
        var expected = [
            CGPoint(x: 1.0, y: 1.0),
            CGPoint(x: 2.0, y: 1.0),
            CGPoint(x: 1.0, y: 0.0),
            CGPoint(x: 0.0, y: 0.0),
            CGPoint(x: 0.0, y: 1.0),
        ]
        measure {
            let hull = ConvexHull(points)
            XCTAssertTrue(hull.isValid)
            XCTAssertEqual(hull.points, expected)
        }

        // Edge case, points on one line are legal
        points = [
            CGPoint(x: 0.0, y: 0.0),
            CGPoint(x: 0.0, y: 1.0),
            CGPoint(x: 0.0, y: 2.0),
        ]
        expected = [
            CGPoint(x: 0.0, y: 1.0),
            CGPoint(x: 0.0, y: 2.0),
            CGPoint(x: 0.0, y: 1.0),
            CGPoint(x: 0.0, y: 0.0),
        ]
        var hull = ConvexHull(points)
        XCTAssertTrue(hull.isValid)
        XCTAssertEqual(hull.points, expected)

        // Edge case, less than three points is illegal
        points = [
            CGPoint(x: 0.0, y: 0.0),
            CGPoint(x: 0.0, y: 1.0)
        ]
        expected = [
            CGPoint(x: 0.0, y: 1.0),
            CGPoint(x: 0.0, y: 0.0)
        ]
        hull = ConvexHull(points)
        XCTAssertFalse(hull.isValid)
    }

//    func testMissionGrid() {
//        // Standard case
//        var points = [
//            CGPoint(x: -2.0, y: 0.0),
//            CGPoint(x: 0.0, y: 2.0),
//            CGPoint(x: 0.0, y: -2.0),
//            CGPoint(x: 2.0, y: 0.0),
//        ]
//        var expected = [
//            CGPoint(x: -0.5, y: -1.5),
//            CGPoint(x: 0.5, y: -1.5),
//            CGPoint(x: 1.5, y: -0.5),
//            CGPoint(x: -1.5, y: -0.5),
//            CGPoint(x: -1.5, y: 0.5),
//            CGPoint(x: 1.5, y: 0.5),
//            CGPoint(x: 0.5, y: 1.5),
//            CGPoint(x: -0.5, y: 1.5),
//        ]
//        measure {
//            let hull = convexHull(points)
//            let grid = missionGrid(hull, 4.0)
//            XCTAssertEqual(grid, expected)
//        }
//
//        // Edge case, invalid hull
//        points = [
//            CGPoint(x: 0.0, y: 0.0),
//            CGPoint(x: 0.0, y: 1.0)
//        ]
//        expected = []
//        let hull = convexHull(points)
//        XCTAssertFalse(hull.isValid)
//        let grid = missionGrid(hull, 4.0)
//        XCTAssertEqual(grid, expected)
//    }
}
