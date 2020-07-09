//
//  MeanderTest.swift
//  AeroGlazTests
//
//  Created by Evgeny Agamirzov on 26.06.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import XCTest
@testable import AeroGlaz

class MeanderTest : XCTestCase {
    func testMeanderReferenceLine() {
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
        let meander = Meander()
        
        // Trivial case positive tangent
        var refLine = meander.referenceLine(for: hull, withTangent: 0.5)
        XCTAssertEqual(refLine, Line(a: 0.5, b: 2.5))

        // Trivial case negative tangent
        refLine = meander.referenceLine(for: hull, withTangent: -2)
        XCTAssertEqual(refLine, Line(a: -2, b: -5))

        // Edge case overlapping line
        refLine = meander.referenceLine(for: hull, withTangent: 1)
        XCTAssertEqual(refLine, Line(a: 1, b: 3))
        refLine = meander.referenceLine(for: hull, withTangent: -0.5)
        XCTAssertEqual(refLine, Line(a: -0.5, b: -2))
    }
}
