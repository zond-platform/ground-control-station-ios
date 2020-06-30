//
//  FillingGrid.swift
//  AeroGlaz
//
//  Created by Evgeny Agamirzov on 26.06.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import CoreGraphics

class Meander : Equatable {
    private(set) var points: [CGPoint] = []
    var isValid = false
}

// Public methods
extension Meander {
    func referenceLine(for hull: ConvexHull, withTangent tangent: CGFloat?) -> Line? {
        var referenceLines: [Line] = []
        for point in hull.points {
            let line = Line(tangent: tangent, point: point)
            let intersectionPoints = hull.intersections(with: line)
            if intersectionPoints.count == 1
               || (intersectionPoints.count == 2
                   && hull.pointsBelongOneEdge(intersectionPoints[0], intersectionPoints[1])) {
                referenceLines.append(line)
            }
        }
        if tangent == nil {
            referenceLines.sort(by: { $0.x! < $1.x! })
        } else {
            referenceLines.sort(by: { tangent! > 0 ? $0.b! > $1.b! : $0.b! < $1.b! })
        }
        return referenceLines.first
    }

    func compute(_ hull: ConvexHull, _ delta: CGFloat, _ tangent: CGFloat?) {
        if hull.isValid && delta != 0.0 {
            if let line = referenceLine(for: hull, withTangent: tangent) {
                // Reset and initialize
                points.removeAll(keepingCapacity: true)
                var direction = true
                var intersectionPoints: [CGPoint] = []

                // Move reference line to an offset
                let offset = delta / 2
                line.move(for: (tangent == nil || tangent! <= 0) ? offset : -offset)

                // Move reference line through the hull
                repeat {
                    // Check intersections and move line further
                    intersectionPoints = hull.intersections(with: line)
                    if tangent == nil {
                        line.move(for: delta)
                        intersectionPoints.sort(by: { direction ? $0.y < $1.y : $0.y > $1.y })
                    } else if tangent! > 0 {
                        line.move(for: -delta)
                        intersectionPoints.sort(by: { direction ? $0.x < $1.x : $0.x > $1.x })
                    } else {
                        line.move(for: delta)
                        intersectionPoints.sort(by: { direction ? $0.x > $1.x : $0.x < $1.x })
                    }

                    // Accumulate the result and reverse direction
                    points.append(contentsOf: intersectionPoints)
                    direction = !direction
                } while !intersectionPoints.isEmpty
                isValid = true
            } else {
                for point in hull.points {
                    let line = Line(tangent: tangent, point: point)
                    let _ = hull.intersectionsDebug(with: line)
                }
                isValid = false
            }
        } else {
            isValid = false
        }
    }
}

func ==(lhs: Meander, rhs: Meander) -> Bool {
    return lhs.points == rhs.points
           && lhs.isValid == rhs.isValid
}
