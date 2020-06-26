//
//  ConvexHull.swift
//  Aeroglaz
//
//  Created by Evgeny Agamirzov on 24.12.19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import CoreGraphics

class ConvexHull : Equatable {
    private let minPoints = 3
    private(set) var points: [CGPoint] = []
    private(set) var vectors: [Vector] = []
    var isValid = false

    init(_ points: [CGPoint]) {
        compute(points)
    }
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
        if !allPoints.isEmpty {
            points.removeAll(keepingCapacity: true)
            vectors.removeAll(keepingCapacity: true)
            let initialPoint = allPoints.min{ left, right in left.x < right.x }!
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
        }
    }

//    func intersections(with vector: Vector) -> [CGPoint] {
//        if !isValid {
//            return []
//        }
//        var intersectionPoints: [CGPoint] = []
//        for hullVector in hullVectors {
//            if let intersectionPoint = hullVector.intersectionPoint(with: vector) {
//                if !intersectionPoints.contains(intersectionPoint) {
//                    intersectionPoints.append(intersectionPoint)
//                }
//            }
//        }
//        return intersectionPoints
//    }
}

func ==(lhs: ConvexHull, rhs: ConvexHull) -> Bool {
    return lhs.points == rhs.points
           && lhs.vectors == rhs.vectors
           && lhs.isValid == rhs.isValid
}
