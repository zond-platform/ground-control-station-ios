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
    
    func testVectorPoint() {
        // Standard cases
        var v = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 4.0, y: 2.0))
        XCTAssertEqual(v.point(y: 1.0), CGPoint(x: 2.0, y: 1.0))
        v = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: -1.0, y: -4.0))
        XCTAssertEqual(v.point(y: -3.0), CGPoint(x: -0.75, y: -3.0))
        XCTAssertEqual(v.point(y: -4.0), CGPoint(x: -1.0, y: -4.0))
        
        // Edge case, y value out of bounds
        v = Vector(CGPoint(x: -1.0, y: 0.0), CGPoint(x: 0.0, y: -1.0))
        XCTAssertEqual(v.point(y: -3.0), nil)
        
        // Edge case, tangent cannot be computed (vertical line)
        v = Vector(CGPoint(x: 1.0, y: 0.0), CGPoint(x: 1.0, y: -1.0))
        XCTAssertEqual(v.point(y: -0.5), CGPoint(x: 1.0, y: -0.5))
    }

    func testVectorMove() {
        // Move vertical vector
        var v = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 2.0))
        v.moveDownAlongNormal(for: 2.0)
        XCTAssertTrue(isEqual(v.startPoint.x, 2.0))
        XCTAssertTrue(isEqual(v.startPoint.y, 0.0))
        XCTAssertTrue(isEqual(v.endPoint.x, 2.0))
        XCTAssertTrue(isEqual(v.endPoint.y, 2.0))

        // Move vector with positive tangent
        v = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 2.0, y: 2.0))
        v.moveDownAlongNormal(for: sqrt(2.0))
        XCTAssertTrue(isEqual(v.startPoint.x, 1.0))
        XCTAssertTrue(isEqual(v.startPoint.y, -1.0))
        XCTAssertTrue(isEqual(v.endPoint.x, 3.0))
        XCTAssertTrue(isEqual(v.endPoint.y, 1.0))

        // Move vector with negative tangent
        v = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: -2.0, y: 2.0))
        v.moveUpAlongNormal(for: sqrt(2.0))
        XCTAssertTrue(isEqual(v.startPoint.x, 1.0))
        XCTAssertTrue(isEqual(v.startPoint.y, 1.0))
        XCTAssertTrue(isEqual(v.endPoint.x, -1.0))
        XCTAssertTrue(isEqual(v.endPoint.y, 3.0))
    }

    func testVectorIntersection() {
        // Trivial case
        var v1 = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 2.0, y: 2.0))
        var v2 = Vector(CGPoint(x: 2.0, y: 0.0), CGPoint(x: 0.0, y: 2.0))
        var point = v1.intersectionPoint(with: v2)
        XCTAssertTrue(point != nil)
        XCTAssertTrue(isEqual(point!.x, 1.0))
        XCTAssertTrue(isEqual(point!.y, 1.0))

        // Edge case with vectors touching common point
        v1 = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 2.0, y: 2.0))
        v2 = Vector(CGPoint(x: 4.0, y: 0.0), CGPoint(x: 2.0, y: 2.0))
        point = v1.intersectionPoint(with: v2)
        XCTAssertTrue(point != nil)
        XCTAssertTrue(isEqual(point!.x, 2.0))
        XCTAssertTrue(isEqual(point!.y, 2.0))

        // Edge case v1 is vertical
        v1 = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 2.0))
        v2 = Vector(CGPoint(x: 1.0, y: 0.0), CGPoint(x: -1.0, y: 2.0))
        point = v1.intersectionPoint(with: v2)
        XCTAssertTrue(point != nil)
        XCTAssertTrue(isEqual(point!.x, 0.0))
        XCTAssertTrue(isEqual(point!.y, 1.0))

        // Edge case v2 is vertical
        v1 = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 2.0, y: 2.0))
        v2 = Vector(CGPoint(x: 1.0, y: 0.0), CGPoint(x: 1.0, y: 2.0))
        point = v1.intersectionPoint(with: v2)
        XCTAssertTrue(point != nil)
        XCTAssertTrue(isEqual(point!.x, 1.0))
        XCTAssertTrue(isEqual(point!.y, 1.0))

        // Edge case v1 and v2 are orthogonal
        v1 = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 2.0))
        v2 = Vector(CGPoint(x: -1.0, y: 1.0), CGPoint(x: 1.0, y: 1.0))
        point = v1.intersectionPoint(with: v2)
        XCTAssertTrue(point != nil)
        XCTAssertTrue(isEqual(point!.x, 0.0))
        XCTAssertTrue(isEqual(point!.y, 1.0))
        
        // Edge case v1 and v2 are parallel and b coefficients are identical
        v1 = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 2.0, y: 2.0))
        v2 = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 3.0, y: 3.0))
        point = v1.intersectionPoint(with: v2)
        XCTAssertTrue(point != nil)
        XCTAssertTrue(isEqual(point!.x, 0.0))
        XCTAssertTrue(isEqual(point!.y, 0.0))

        // Edge case v1 and v2 are parallel but b coefficients are different
        v1 = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 2.0))
        v2 = Vector(CGPoint(x: 1.0, y: 0.0), CGPoint(x: 1.0, y: 2.0))
        point = v1.intersectionPoint(with: v2)
        XCTAssertTrue(point == nil)
        v1 = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 2.0, y: 2.0))
        v2 = Vector(CGPoint(x: 1.0, y: 0.0), CGPoint(x: 3.0, y: 2.0))
        point = v1.intersectionPoint(with: v2)
        XCTAssertTrue(point == nil)

        // Edge case v1 and v2 intersect but outside of the vector span
        v1 = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 3.0, y: 3.0))
        v2 = Vector(CGPoint(x: 3.0, y: 0.0), CGPoint(x: 4.0, y: 3.0))
        point = v1.intersectionPoint(with: v2)
        XCTAssertTrue(point == nil)
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
    
    func testMissionGrid() {
        // Standard case
        var points = [
            CGPoint(x: -2.0, y: 0.0),
            CGPoint(x: 0.0, y: 2.0),
            CGPoint(x: 0.0, y: -2.0),
            CGPoint(x: 2.0, y: 0.0),
        ]
        var expected = [
            CGPoint(x: -0.5, y: -1.5),
            CGPoint(x: 0.5, y: -1.5),
            CGPoint(x: 1.5, y: -0.5),
            CGPoint(x: -1.5, y: -0.5),
            CGPoint(x: -1.5, y: 0.5),
            CGPoint(x: 1.5, y: 0.5),
            CGPoint(x: 0.5, y: 1.5),
            CGPoint(x: -0.5, y: 1.5),
        ]
        measure {
            let hull = convexHull(points)
            let grid = missionGrid(hull, 4.0)
            XCTAssertEqual(grid, expected)
        }
        
        // Edge case, invalid hull
        points = [
            CGPoint(x: 0.0, y: 0.0),
            CGPoint(x: 0.0, y: 1.0)
        ]
        expected = []
        let hull = convexHull(points)
        XCTAssertFalse(hull.isValid)
        let grid = missionGrid(hull, 4.0)
        XCTAssertEqual(grid, expected)
    }
}
