//
//  ConvexHull.swift
//  Aeroglaz
//
//  Created by Evgeny Agamirzov on 24.12.19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import CoreGraphics

class ConvexHull : Equatable {
    private let minHullPoints = 3
    private var hullPoints: [CGPoint] = []
    private var hullVectors: [Vector] = []
    var isValid = false
}

// Public methods
extension ConvexHull {
    func add(_ vector: Vector) {
        hullVectors.append(vector)
        hullPoints.append(vector.endPoint)
        if hullPoints.count >= minHullPoints {
            isValid = true
        }
    }

    func points() -> [CGPoint] {
        return hullPoints
    }

    func vectors() -> [Vector] {
        return hullVectors
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
    return lhs.points() == rhs.points()
           && lhs.vectors() == rhs.vectors()
           && lhs.isValid == rhs.isValid
}
