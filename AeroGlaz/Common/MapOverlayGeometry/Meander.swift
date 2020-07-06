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
}

// Public methods
extension Meander {
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

    func compute(_ hull: Hull, _ delta: CGFloat, _ tangent: CGFloat?) {
        if delta != 0.0 {
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
            }
        }
    }
}

func ==(lhs: Meander, rhs: Meander) -> Bool {
    return lhs.points == rhs.points
}
