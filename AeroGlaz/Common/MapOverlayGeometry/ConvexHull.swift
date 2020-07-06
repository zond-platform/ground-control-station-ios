//
//  ConvexHull.swift
//  Aeroglaz
//
//  Created by Evgeny Agamirzov on 24.12.19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import CoreGraphics

enum HullTraverseDirection {
    case forward
    case backward
}

class ConvexHull : Equatable {
    private(set) var points: [CGPoint] = []
    private(set) var vectors: [Vector] = []
}

// Public methods
extension ConvexHull {
    // Jarvis algorithm (gift wrapping)
    func compute(_ allPoints: [CGPoint]) {
        if let initialPoint = allPoints.min(by: { $0.x <= $1.x }) {
            points.removeAll(keepingCapacity: true)
            vectors.removeAll(keepingCapacity: true)
            var referenceVector = Vector(endPoint: initialPoint)
            repeat {
                var nextVector = Vector(at: initialPoint)
                var minTheta = CGFloat.pi
                for currentPoint in allPoints {
                    if currentPoint != referenceVector.endPoint {
                        let currentVector = Vector(referenceVector.endPoint, currentPoint)
                        let currentTheta = referenceVector.theta(currentVector)
                        if currentTheta < minTheta {
                            minTheta = currentTheta
                            nextVector = currentVector
                        } else if currentTheta == minTheta {
                            nextVector = currentVector.norm < nextVector.norm || nextVector.norm == 0.0
                                         ? currentVector
                                         : nextVector
                        }
                    }
                }
                referenceVector = nextVector
                vectors.append(nextVector)
                points.append(nextVector.endPoint)
            } while referenceVector.endPoint != initialPoint
        }
    }

    func intersections(with line: Line) -> [CGPoint] {
        var result: [CGPoint] = []
        for vector in vectors {
            let intersectionPoints = vector.intersectionPoint(with: line)
            for point in intersectionPoints {
                if !result.contains(point) {
                    result.append(point)
                }
            }
        }
        return result
    }
}

func ==(lhs: ConvexHull, rhs: ConvexHull) -> Bool {
    return lhs.points == rhs.points
           && lhs.vectors == rhs.vectors
}
