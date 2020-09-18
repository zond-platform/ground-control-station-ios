//
//  FillingGrid.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 26.06.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import CoreGraphics

class Meander : Equatable {
    private(set) var points: [CGPoint] = []
    private var intersectionPoints: [CGPoint] = []
}

// Public methods
extension Meander {
    func compute(_ hull: Hull, _ delta: CGFloat, _ tangent: CGFloat?) {
        if delta != 0.0 {
            if let line = referenceLine(for: hull, withTangent: tangent) {
                // Reset and initialize
                points.removeAll(keepingCapacity: true)
                intersectionPoints.removeAll(keepingCapacity: true)
                var direction = true

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

                    // Align points on turn
                    if points.count >= 2 && intersectionPoints.count == 2 {
                        let v1 = Vector(points[points.count - 2], points[points.count - 1])
                        let v2 = Vector(intersectionPoints[0], intersectionPoints[1])
                        alignTurn(&points[points.count - 1], &intersectionPoints[0], v1, v2, tangent, delta, direction)
                    }

                    // Accumulate the result
                    points.append(contentsOf: intersectionPoints)

                    // Reverse meander direction
                    direction = !direction
                } while !intersectionPoints.isEmpty
            }
        }
    }

    func referenceLine(for hull: Hull, withTangent tangent: CGFloat?) -> Line? {
        var referenceLines: [Line] = []
        for point in hull.points {
            referenceLines.append(Line(tangent: tangent, point: point))
        }
        if tangent == nil {
            referenceLines.sort(by: { $0.x! < $1.x! })
        } else {
            referenceLines.sort(by: { tangent! > 0 ? $0.b! > $1.b! : $0.b! < $1.b! })
        }
        return referenceLines.first
    }

    func alignTurn(_ p1: inout CGPoint,
                   _ p2: inout CGPoint,
                   _ v1: Vector,
                   _ v2: Vector,
                   _ tangent: CGFloat?,
                   _ delta: CGFloat,
                   _ direction: Bool) {
        // Meander lines to transition between
        let l1 = Line(tangent: tangent, point: p1)
        let l2 = Line(tangent: tangent, point: p2)

        // Build perpendicular line on farthest turn point
        let v = Vector(p1, p2)
        let l = v.theta(v1) > v.theta(v2) ? Line(tangent: flipTangent(tangent), point: p1)
                                          : Line(tangent: flipTangent(tangent), point: p2)

        // Move perpendicular line farther to increase turn space
        tangent == 0 ? l.move(for: direction ? delta / 2 : -delta / 2)
                     : l.move(for: direction ? -delta / 2 : delta / 2)

        // Assign aligned turn points
        p1 = intersectionPoint(l1, l)
        p2 = intersectionPoint(l2, l)
    }
}

// Private functions
extension Meander {
    private func flipTangent(_ tangent: CGFloat?) -> CGFloat? {
        if tangent == nil {
            return 0
        } else if tangent! == 0 {
            return nil
        } else {
            return 1 / -tangent!
        }
    }

    private func intersectionPoint(_ l1: Line, _ l2: Line) -> CGPoint {
        return try! l1.intersectionPoint(with: l2).get()
    }
}

func ==(lhs: Meander, rhs: Meander) -> Bool {
    return lhs.points == rhs.points
}
