//
//  Geometry.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 27.10.19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import CoreGraphics

func norm(_ v: Vector) -> CGFloat {
    return sqrt(pow(v.dx, 2) + pow(v.dy, 2))
}

func dot(_ v: Vector, _ u: Vector) -> CGFloat {
    return v.dx * u.dx + v.dy * u.dy
}

func theta(_ v: Vector, _ u: Vector) -> CGFloat {
    return acos(dot(v, u) / (norm(v) * norm(u)))
}

class Vector : Equatable {
    public let startPoint, endPoint: CGPoint
    public let dx, dy: CGFloat
    public let minY, maxY: CGFloat
    
    // Creates a null vector
    convenience init() {
        self.init(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0))
    }
    
    // Creates an identitiy vector parrallel to the y axis
    convenience init(endPoint: CGPoint) {
        self.init(CGPoint(x: endPoint.x, y: endPoint.y - 1.0), endPoint)
    }
    
    // Creates a vector from start to end point
    init(_ startPoint: CGPoint, _ endPoint: CGPoint) {
        self.startPoint = startPoint
        self.endPoint = endPoint
        
        self.dx = endPoint.x - startPoint.x
        self.dy = endPoint.y - startPoint.y
        
        let comparison = endPoint.y > startPoint.y
        self.minY = comparison ? startPoint.y : endPoint.y
        self.maxY = comparison ? endPoint.y : startPoint.y
    }
    
    // Returns an intersection point between a vector and the provided y value
    func point(y: CGFloat) -> CGPoint? {
        guard y >= minY && y <= maxY else {
            return nil
        }
        guard dx != 0.0 else {
            return CGPoint(x: startPoint.x, y: y)
        }
        
        let a = dy / dx
        let b = startPoint.y - a * startPoint.x
        let x = (y - b) / a
        
        return CGPoint(x: x, y: y)
    }
}

func ==(lhs: Vector, rhs: Vector) -> Bool {
    return lhs.startPoint == rhs.startPoint
           && lhs.endPoint == rhs.endPoint
}

class ConvexHull : Equatable {
    let minHullPoints = 3
    var isValid = false
    private var hullPoints: [CGPoint] = []
    private var hullVectors: [Vector] = []
    
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
}

func ==(lhs: ConvexHull, rhs: ConvexHull) -> Bool {
    return lhs.points() == rhs.points()
           && lhs.vectors() == rhs.vectors()
           && lhs.isValid == rhs.isValid
}

func leftmost(_ allPoints: [CGPoint]) -> CGPoint {
    return allPoints.min{ left, right in left.x < right.x } ?? CGPoint(x: 0.0, y: 0.0)
}

func rightmost(_ allPoints: [CGPoint]) -> CGPoint {
    return allPoints.max{ left, right in left.x < right.x } ?? CGPoint(x: 0.0, y: 0.0)
}

func lowermost(_ allPoints: [CGPoint]) -> CGPoint {
    return allPoints.min{ left, right in left.y < right.y } ?? CGPoint(x: 0.0, y: 0.0)
}

func uppermost(_ allPoints: [CGPoint]) -> CGPoint {
    return allPoints.max{ left, right in left.y < right.y } ?? CGPoint(x: 0.0, y: 0.0)
}

func convexHull(_ allPoints: [CGPoint]) -> ConvexHull {
    let convexHull = ConvexHull()
    guard !allPoints.isEmpty else {
        return convexHull
    }
    
    // Jarvis algorithm (gift wrapping)
    let initialPoint = leftmost(allPoints)
    var referenceVector = Vector(endPoint: initialPoint)
    repeat {
        var nextVector = Vector()
        var minTheta = CGFloat.pi
        for currentPoint in allPoints {
            if currentPoint != referenceVector.endPoint {
                let currentVector = Vector(referenceVector.endPoint, currentPoint)
                let currentTheta = theta(referenceVector, currentVector)
                if currentTheta < minTheta {
                    minTheta = currentTheta
                    nextVector = currentVector
                } else if currentTheta == minTheta {
                    nextVector = norm(currentVector) < norm(nextVector) || norm(nextVector) == 0.0
                                 ? currentVector
                                 : nextVector
                }
            }
        }
        referenceVector = nextVector
        convexHull.add(nextVector)
    } while referenceVector.endPoint != initialPoint

    return convexHull
}

func missionGrid(_ convexHull: ConvexHull, _ gridDelta: CGFloat) -> [CGPoint] {
    guard convexHull.isValid else {
        return []
    }
    
    let uppermostPoint = uppermost(convexHull.points())
    let lowermostPoint = lowermost(convexHull.points())

    var direction = false
    var gridPoints: [CGPoint] = []
    let delta = (uppermostPoint.y - lowermostPoint.y) / gridDelta
    var referenceLine = lowermostPoint.y + delta / 2.0

    while referenceLine < uppermostPoint.y {
        var intersectionPoints: [CGPoint] = []
        for vector in convexHull.vectors() {
            let point = vector.point(y: referenceLine)
            guard point != nil else {
                continue
            }
            guard !intersectionPoints.contains(point!) else {
                continue
            }
            intersectionPoints.append(point!)
        }

        referenceLine += delta
        direction = !direction
        intersectionPoints.sort(by: { a, b in direction ? a.x < b.x : a.x > b.x })
        gridPoints.append(contentsOf: intersectionPoints)
    }
    
    return gridPoints
}
