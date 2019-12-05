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
        self.init(CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0))
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
    return lhs.startPoint == rhs.startPoint && lhs.endPoint == rhs.endPoint
}

class PointSet {
    private let points: [CGPoint]
    private let minNumPoints = 3
    var gridDelta: CGFloat
    
    public var hullPoints: [CGPoint] = []
    public var hullVectors: [Vector] = []
    public var gridPoints: [CGPoint] = []
    
    public var leftmostPoint: CGPoint?
    public var rightmostPoint: CGPoint?
    public var uppermostPoint: CGPoint?
    public var lowermostPoint: CGPoint?
    
    init(_ points: [CGPoint] = [], _ gridDelta: CGFloat = 10.0) {
        self.points = points
        self.gridDelta = gridDelta
        guard points.count >= minNumPoints else {
            return
        }

        self.leftmostPoint = points.min{ a, b in a.x < b.x }!
        self.rightmostPoint = points.min{ a, b in a.x > b.x }!
        self.uppermostPoint = points.min{ a, b in a.y > b.y }!
        self.lowermostPoint = points.min{ a, b in a.y < b.y }!
        
        self.calculateHull()
        self.calculateGrid()
    }
    
    // Jarvis algorithm (gift wrapping)
    // TODO: Try out more efficient algorithms
    private func calculateHull() {
        var referenceVector = Vector(endPoint: leftmostPoint!)
        repeat {
            var nextVector = Vector()
            var minTheta = CGFloat.pi

            for currentPoint in points {
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
            hullPoints.append(nextVector.endPoint)
            hullVectors.append(nextVector)
        } while referenceVector.endPoint != leftmostPoint!
    }
    
    private func calculateGrid() {
        let delta = (uppermostPoint!.y - lowermostPoint!.y) / gridDelta
        var referenceLine = lowermostPoint!.y + delta / 2.0
        var direction = false
        
        while referenceLine < uppermostPoint!.y {
            var intersectionPoints: [CGPoint] = []
            for vector in hullVectors {
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

            // Sort according to current direction before appending
            intersectionPoints.sort(by: { a, b in
                direction ? a.x < b.x : a.x > b.x
            })
            gridPoints.append(contentsOf: intersectionPoints)
        }
    }
}
