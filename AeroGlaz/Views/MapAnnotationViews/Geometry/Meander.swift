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
    private var intersectionPoints: [CGPoint] = []
    private var v1: Vector?
    private var v2: Vector?
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
                    if points.count > 1 && intersectionPoints.count == 2 {
                        v1 = Vector(points[points.count - 1], points[points.count - 2])
                        v2 = Vector(intersectionPoints[0], intersectionPoints[1])
                        alignedTurn(&points[points.count - 1], &intersectionPoints[0], tangent)
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

    func alignedTurn(_ p1: inout CGPoint,
                     _ p2: inout CGPoint,
                     _ tangent: CGFloat?) {
        // Meander lines through turn points
        let l1 = Line(tangent: tangent, point: p1)
        let l2 = Line(tangent: tangent, point: p2)

        // Perpendicular meander lines through turn points
        let flippedTangent = flipTangent(tangent)
        let l_1 = Line(tangent: flippedTangent, point: p1)
        let l_2 = Line(tangent: flippedTangent, point: p2)

        // Find projection points
        let p_1 = intersection(l1, l_2)!
        let p_2 = intersection(l2, l_1)!

        // Check which projection is beyond polygon boundaries
        if let contains = v1?.span.contains(p_1) {
            if !contains {
                p1 = p_1
            }
        }
        if let contains = v2?.span.contains(p_2) {
            if !contains {
                p2 = p_2
            }
        }
    }

    func flipTangent(_ tangent: CGFloat?) -> CGFloat? {
        if tangent == nil {
            return 0
        } else if tangent! == 0 {
            return nil
        } else {
            return 1 / -tangent!
        }
    }

    func intersection(_ l1: Line, _ l2: Line) -> CGPoint? {
        switch l1.intersectionPoint(with: l2) {
            case .success(let point):
                return point
            case .failure:
                return nil
        }
    }
}

func ==(lhs: Meander, rhs: Meander) -> Bool {
    return lhs.points == rhs.points
}
