//
//  GeometryTests.swift
//  GeometryTests
//
//  Created by Evgeny Agamirzov on 27/10/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import XCTest
@testable import DroneMap

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
    
    func testPointSet() {
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
            let pointSet = PointSet(points)
            XCTAssertEqual(pointSet.leftmostPoint!, CGPoint(x: 0.0, y: 1.0))
            XCTAssertEqual(pointSet.uppermostPoint!, CGPoint(x: 2.0, y: 1.0))
            XCTAssertEqual(pointSet.lowermostPoint!, CGPoint(x: 0.0, y: 0.0))
            XCTAssertEqual(pointSet.hullPoints, expected)
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
        var pointSet = PointSet(points)
        XCTAssertEqual(pointSet.leftmostPoint!, CGPoint(x: 0.0, y: 0.0))
        XCTAssertEqual(pointSet.uppermostPoint!, CGPoint(x: 0.0, y: 2.0))
        XCTAssertEqual(pointSet.lowermostPoint!, CGPoint(x: 0.0, y: 0.0))
        XCTAssertEqual(pointSet.hullPoints, expected)

        
        // Edge case, empty point set if less than two points provided
        points = [CGPoint(x: 0.0, y: 0.0),
                  CGPoint(x: 0.0, y: 1.0)]
        pointSet = PointSet(points)
        XCTAssertEqual(pointSet.leftmostPoint, nil)
        XCTAssertEqual(pointSet.uppermostPoint, nil)
        XCTAssertEqual(pointSet.lowermostPoint, nil)
        XCTAssertEqual(pointSet.hullPoints, [])
    }
    
    func testGrid() {
        // Standard case
        let points = [
            CGPoint(x: -2.0, y: 0.0),
            CGPoint(x: 0.0, y: 2.0),
            CGPoint(x: 0.0, y: -2.0),
            CGPoint(x: 2.0, y: 0.0),
        ]
        let expected = [
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
            let pointSet = PointSet(points, 4.0)
            XCTAssertEqual(pointSet.leftmostPoint!, CGPoint(x: -2.0, y: 0.0))
            XCTAssertEqual(pointSet.uppermostPoint!, CGPoint(x: 0.0, y: 2.0))
            XCTAssertEqual(pointSet.lowermostPoint!, CGPoint(x: 0.0, y: -2.0))
            XCTAssertEqual(pointSet.gridPoints, expected)
        }
    }
}
