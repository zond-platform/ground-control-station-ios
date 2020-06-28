//
//  PointSet.swift
//  AeroGlaz
//
//  Created by Evgeny Agamirzov on 26.06.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import CoreGraphics

class PointSet {
    private var points: [CGPoint] = []
    private var hull = ConvexHull()
    var meander = Meander()
}

// Public methods
extension PointSet {
    func append(point: CGPoint) {
        points.append(point)
    }

    func update(point: CGPoint, at id: Int) {
        points[id] = point
    }

    func recomputeShapes(_ delta: CGFloat, _ tangent: CGFloat) {
        hull.compute(points)
        meander.compute(hull, delta, tangent)
    }

    func convexHull() -> [CGPoint] {
        return hull.isValid ? hull.points : []
    }

    func meanderGrid() -> [CGPoint] {
        return meander.isValid ? meander.points : []
    }

    func leftmost() -> CGPoint {
        return points.min{ left, right in left.x < right.x } ?? CGPoint(x: 0.0, y: 0.0)
    }

    func rightmost() -> CGPoint {
        return points.max{ left, right in left.x < right.x } ?? CGPoint(x: 0.0, y: 0.0)
    }

    func lowermost() -> CGPoint {
        return points.min{ left, right in left.y < right.y } ?? CGPoint(x: 0.0, y: 0.0)
    }

    func uppermost() -> CGPoint {
        return points.max{ left, right in left.y < right.y } ?? CGPoint(x: 0.0, y: 0.0)
    }

    func enclosingRect() -> CGRect {
        let left = leftmost()
        let right = rightmost()
        let low = lowermost()
        let up = uppermost()

        let origin = CGPoint(x: left.x, y: low.y)
        let width = Double(right.x) - Double(left.x)
        let height = Double(up.y) - Double(low.y)

        return CGRect(origin: origin, size: CGSize(width: width, height: height))
    }
}
