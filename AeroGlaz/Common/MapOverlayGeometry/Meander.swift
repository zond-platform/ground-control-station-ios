//
//  FillingGrid.swift
//  AeroGlaz
//
//  Created by Evgeny Agamirzov on 26.06.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import CoreGraphics

class Meander : Equatable {
    private let minPoints = 2
    private(set) var points: [CGPoint] = []
    var isValid = false

    init(_ points: [CGPoint]) {
        compute(points)
    }
}

// Private methods
extension Meander {
    private func add(_ vector: Vector) {

    }
}

// Public methods
extension Meander {
    func compute(_ allPoints: [CGPoint]) {
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
    }
}

func ==(lhs: Meander, rhs: Meander) -> Bool {
    return lhs.points == rhs.points
           && lhs.isValid == rhs.isValid
}
