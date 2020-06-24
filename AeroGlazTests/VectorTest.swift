//
//  VectorTest.swift
//  AeroGlazTests
//
//  Created by Evgeny Agamirzov on 25.06.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import XCTest
@testable import AeroGlaz

class VectorTest: XCTestCase {
    let eps = CGFloat(10e-6)

    func testVectorsAngleCaculation() {
        // Trivial case
        var v = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 2.0, y: 2.0))
        var u = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 3.0, y: 0.0))
        XCTAssertEqual(norm(v), sqrt(8.0))
        XCTAssertEqual(norm(u), sqrt(9.0))
        XCTAssertEqual(dot(v, u), 6.0)
        XCTAssertEqual(theta(v, u), CGFloat.pi / 4, accuracy: eps)

        // Edge case, parallel vectors
        v = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 2.0, y: 0.0))
        u = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 3.0, y: 0.0))
        XCTAssertEqual(norm(v), sqrt(4.0))
        XCTAssertEqual(norm(u), sqrt(9.0))
        XCTAssertEqual(dot(v, u), 6.0)
        XCTAssertEqual(theta(v, u), 0.0, accuracy: eps)

        // Edge case, anti-parallel vectors
        v = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 2.0, y: 2.0))
        u = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: -2.0, y: -2.0))
        XCTAssertEqual(norm(v), sqrt(8.0))
        XCTAssertEqual(norm(u), sqrt(8.0))
        XCTAssertEqual(dot(v, u), -8.0)
        XCTAssertEqual(theta(v, u), CGFloat.pi, accuracy: eps)
    }
}
