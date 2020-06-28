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

    // Debug
    private(set) var failedPoints: [CGPoint] = []
    private(set) var failedVectors: [Vector] = []
}

// Public methods
extension Meander {
    func referenceLine(for hull: ConvexHull, withTangent tangent: CGFloat?) -> Line {
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
            referenceLines.sort(by: { $0.x! > $1.x! })
        } else {
            referenceLines.sort(by: { tangent! > 0 ? $0.b! > $1.b! : $0.b! < $1.b! })
        }
        return referenceLines.first!
    }

    func compute(_ hull: ConvexHull, _ delta: CGFloat, _ tangent: CGFloat?) {
        if hull.isValid && delta != 0.0 {
            // Reset and initialize
            points.removeAll(keepingCapacity: true)
//            failedPoints.removeAll(keepingCapacity: true)
//            failedVectors.removeAll(keepingCapacity: true)
//
//            for point in hull.points {
//                let line = Line(tangent: tangent, point: point)
//                let intersectionPoints = hull.intersections(with: line)
//                if intersectionPoints.count == 0 {
//                    failedPoints.append(point)
//                    let height = CGFloat(1000)
//                    let startPoint = CGPoint(x: (-height - line.b!) / line.a!, y: -height)
//                    let endPoint = CGPoint(x: (height - line.b!) / line.a!, y: height)
//                    failedVectors.append(Vector(startPoint, endPoint))
//
//                    let points = hull.vector(for: point).intersectionPoint(with: line)
////                    print("isEmpty??? \(points.isEmpty)")
//                    print("NO INTERSECTIONS")
//                } else {
////                    print("Line: \(line.a!)x + \(line.b!)")
////                    print("Point: \(point)")
////                    print("Epsilon: \(point.y - line.a!*point.x - line.b!)")
////                    hull.printVertex(point)
////                    print(intersectionPoints)
////                    print("----------------------")
//                    print(intersectionPoints.count)
//                }
//            }
            
            let line = referenceLine(for: hull, withTangent: tangent)
            var direction = true
            var intersectionPoints: [CGPoint] = []

            // Move reference line through the hull
            repeat {
                if tangent == nil {
                    line.move(for: delta)
                } else {
                    line.move(for: tangent! > 0 ? -delta : delta)
                }

                // Check intersections
                intersectionPoints = hull.intersections(with: line)
                if !direction {
                    intersectionPoints.reverse()
                }

                // Accumulate the result and reverse direction
                points.append(contentsOf: intersectionPoints)
                direction = !direction
            } while !intersectionPoints.isEmpty
            isValid = true
        } else {
            isValid = false
        }
    }
}

func ==(lhs: Meander, rhs: Meander) -> Bool {
    return lhs.points == rhs.points
           && lhs.isValid == rhs.isValid
}
