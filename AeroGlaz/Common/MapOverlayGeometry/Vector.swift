//
//  Vector.swift
//  Aeroglaz
//
//  Created by Evgeny Agamirzov on 24.12.19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import CoreGraphics

class Vector : Equatable {
    // Stored properties
    var startPoint, endPoint: CGPoint

    // Computed properties (vector parameters)
    var dx: CGFloat { endPoint.x - startPoint.x }
    var dy: CGFloat { endPoint.y - startPoint.y }
    var minX: CGFloat { endPoint.x > startPoint.x ? startPoint.x : endPoint.x }
    var minY: CGFloat { endPoint.y > startPoint.y ? startPoint.y : endPoint.y }
    var maxX: CGFloat { endPoint.x > startPoint.x ? endPoint.x : startPoint.x }
    var maxY: CGFloat { endPoint.y > startPoint.y ? endPoint.y : startPoint.y }

    // Computed properties (line equasion coefficients)
    var a: CGFloat { dy / dx }
    var b: CGFloat { startPoint.y - a * startPoint.x }
    
    // Create a null vector
    convenience init() {
        self.init(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0))
    }
    
    // Create an identitiy vector parrallel to the y axis
    convenience init(endPoint: CGPoint) {
        self.init(CGPoint(x: endPoint.x, y: endPoint.y - 1.0), endPoint)
    }

    // Create a vector from center point, norm and angle
    convenience init(centerPoint: CGPoint, norm: CGFloat, angle: CGFloat) {
        let ddx = norm * cos(angle) / 2
        let ddy = norm * sin(angle) / 2
        self.init(CGPoint(x: centerPoint.x - ddx, y: centerPoint.y - ddy),
                  CGPoint(x: centerPoint.x + ddx, y: centerPoint.y + ddy))
    }
    
    // Create a vector from start to end point
    init(_ startPoint: CGPoint, _ endPoint: CGPoint) {
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}

// Public methods
extension Vector {
    // Find an intersection point between a vector and the provided y value
    func point(y: CGFloat) -> CGPoint? {
        guard y >= minY && y <= maxY else {
            return nil
        }
        guard dx != 0.0 else {
            return CGPoint(x: startPoint.x, y: y)
        }        
        return CGPoint(x: (y - b) / a, y: y)
    }

    // Move vector along its normal down the coordinate system
    func moveDownAlongNormal(for distance: CGFloat) {
        let angle = dx == 0.0 ? (CGFloat(Double.pi) / 2) : atan(a)
        let ddx = distance * sin(angle)
        let ddy = distance * cos(angle)
        startPoint.x += ddx
        startPoint.y += -ddy
        endPoint.x += ddx
        endPoint.y += -ddy
    }

    // Move vector along its normal up the coordinate system
    func moveUpAlongNormal(for distance: CGFloat) {
        let angle = dx == 0.0 ? (CGFloat(Double.pi) / 2) : atan(a)
        let ddx = distance * sin(angle)
        let ddy = distance * cos(angle)
        startPoint.x += -ddx
        startPoint.y += ddy
        endPoint.x += -ddx
        endPoint.y += ddy
    }

    // Checks if a given pointlies within vector coordinate span
    func containsPoint(_ point: CGPoint) -> Bool {
        return point.x >= minX && point.x <= maxX
               && point.y >= minY && point.y <= maxY
    }

    // Find intersection points between given vectors
    func intersectionPoint(with vector: Vector) -> CGPoint? {
        var intersectionPoint = CGPoint()
        if dx == 0 && vector.dx == 0 {
            return nil
        } else if a == vector.a && b != vector.b {
            return nil
        } else if a == vector.a && b == vector.b {
            let x = startPoint.x
            intersectionPoint = CGPoint(x: x, y: vector.a * x + vector.b)
        } else if dx == 0 {
            let x = startPoint.x
            intersectionPoint = CGPoint(x: x, y: vector.a * x + vector.b)
        } else if vector.dx == 0 {
            let x = vector.startPoint.x
            intersectionPoint = CGPoint(x: x, y: a * x + b)
        } else {
            let x = (vector.b - b) / (a - vector.a)
            intersectionPoint = CGPoint(x: x, y: a * x + b)
        }
        return containsPoint(intersectionPoint) ? intersectionPoint : nil
    }
}

func ==(lhs: Vector, rhs: Vector) -> Bool {
    return lhs.startPoint == rhs.startPoint
           && lhs.endPoint == rhs.endPoint
}
