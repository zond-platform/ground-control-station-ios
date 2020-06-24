//
//  GeometryTests.swift
//  GeometryTests
//
//  Created by Evgeny Agamirzov on 27/10/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import XCTest
@testable import AeroGlaz

class GeometryTests: XCTestCase {
    let pi = CGFloat(Double.pi)
    let eps = CGFloat(10e-6)

    func isEqual(_ a: CGFloat, _ b: CGFloat) -> Bool {
        return abs(a - b) < eps
    }

    func testVectorsAngleCaculation() {
        // Standard case
        var v = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 2.0, y: 2.0))
        var u = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 3.0, y: 0.0))
        XCTAssertEqual(norm(v), sqrt(8.0))
        XCTAssertEqual(norm(u), sqrt(9.0))
        XCTAssertEqual(dot(v, u), 6.0)
        XCTAssertTrue(isEqual(theta(v, u), pi / 4))
        
        // Edge case, parallel vectors
        v = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 2.0, y: 0.0))
        u = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 3.0, y: 0.0))
        XCTAssertEqual(norm(v), sqrt(4.0))
        XCTAssertEqual(norm(u), sqrt(9.0))
        XCTAssertEqual(dot(v, u), 6.0)
        XCTAssertTrue(isEqual(theta(v, u), 0.0))
        
        // Edge case, anti-parallel vectors
        v = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 2.0, y: 2.0))
        u = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: -2.0, y: -2.0))
        XCTAssertEqual(norm(v), sqrt(8.0))
        XCTAssertEqual(norm(u), sqrt(8.0))
        XCTAssertEqual(dot(v, u), -8.0)
        XCTAssertTrue(isEqual(theta(v, u), pi))
    }

    func testConvexHull() {
        // Standard case
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
            let hull = convexHull(points)
            XCTAssertTrue(hull.isValid)
            XCTAssertEqual(hull.points(), expected)
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
        var hull = convexHull(points)
        XCTAssertTrue(hull.isValid)
        XCTAssertEqual(hull.points(), expected)

        // Edge case, less than three points is illegal
        points = [
            CGPoint(x: 0.0, y: 0.0),
            CGPoint(x: 0.0, y: 1.0)
        ]
        expected = [
            CGPoint(x: 0.0, y: 1.0),
            CGPoint(x: 0.0, y: 0.0)
        ]
        hull = convexHull(points)
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
