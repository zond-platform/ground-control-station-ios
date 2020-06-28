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
    private(set) var isValid = false
    private let minPoints = 3
}

// Private methods
extension ConvexHull {
    private func add(_ vector: Vector) {
        vectors.append(vector)
        points.append(vector.endPoint)
        if points.count >= minPoints {
            isValid = true
        }
    }
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
                var nextVector = Vector()
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
                add(nextVector)
            } while referenceVector.endPoint != initialPoint
        } else {
            isValid = false
        }
    }

    func intersections(with line: Line) -> [CGPoint] {
        if isValid {
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
        } else {
            return []
        }
    }

    func pointsBelongOneEdge(_ point1: CGPoint, _ point2: CGPoint) -> Bool {
        for vector in vectors {
            if (vector.startPoint == point1 && vector.endPoint == point2)
                || (vector.startPoint == point2 && vector.endPoint == point1) {
                return true
            }
        }
        return false
    }
}

func ==(lhs: ConvexHull, rhs: ConvexHull) -> Bool {
    return lhs.points == rhs.points
           && lhs.vectors == rhs.vectors
           && lhs.isValid == rhs.isValid
}
