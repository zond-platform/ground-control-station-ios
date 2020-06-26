//
//  PointSet.swift
//  AeroGlaz
//
//  Created by Evgeny Agamirzov on 26.06.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import CoreGraphics

class PointSet {
    private var points: [CGPoint]
    private var hull: ConvexHull

    init(_ points: [CGPoint] = []) {
        self.points = points
        self.hull = ConvexHull(points)
    }
}

// Public methods
extension PointSet {
    func append(point: CGPoint) {
        points.append(point)
    }

    func update(point: CGPoint, at id: Int) {
        points[id] = point
    }

    func convexHull() -> [CGPoint] {
        hull.compute(points)
        return hull.isValid ? hull.points : []
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

//func missionGrid(_ convexHull: ConvexHull, _ gridDelta: CGFloat) -> [CGPoint] {
//    guard convexHull.isValid && gridDelta != 0.0 else {
//        return []
//    }
//
//    let uppermostPoint = uppermost(convexHull.points())
//    let lowermostPoint = lowermost(convexHull.points())
//
//    var direction = false
//    var gridPoints: [CGPoint] = []
//    let delta = (uppermostPoint.y - lowermostPoint.y) / gridDelta
//    var referenceLine = lowermostPoint.y + delta / 2.0
//
//    while referenceLine < uppermostPoint.y {
//        var intersectionPoints: [CGPoint] = []
//        for vector in convexHull.vectors() {
//            let point = vector.point(y: referenceLine)
//            guard point != nil else {
//                continue
//            }
//            guard !intersectionPoints.contains(point!) else {
//                continue
//            }
//            intersectionPoints.append(point!)
//        }
//
//        referenceLine += delta
//        direction = !direction
//        intersectionPoints.sort(by: { a, b in direction ? a.x < b.x : a.x > b.x })
//        gridPoints.append(contentsOf: intersectionPoints)
//    }
//
//    return gridPoints
//    return []
//}
