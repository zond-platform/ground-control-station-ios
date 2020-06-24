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
    private(set) var startPoint: CGPoint
    private(set) var endPoint: CGPoint

    // Computed properties (vector parameters)
    var dx: CGFloat { endPoint.x - startPoint.x }
    var dy: CGFloat { endPoint.y - startPoint.y }
    let minX: CGFLoat { endPoint.x > startPoint.x ? startPoint.x : endPoint.x }
    let minY: CGFLoat { endPoint.y > startPoint.y ? startPoint.y : endPoint.y }
    var line: Line { Line(self) }

    // Create a null vector
    convenience init() {
        self.init(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0))
    }

    // Create an identitiy vector parrallel to the y axis
    convenience init(endPoint: CGPoint) {
        self.init(CGPoint(x: endPoint.x, y: endPoint.y - 1.0), endPoint)
    }

    // Create a vector from start to end point
    init(_ startPoint: CGPoint, _ endPoint: CGPoint) {
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}

// Public methods
extension Vector {
    // Checks if a given point lies within vector coordinate span
    func contains(_ point: CGPoint) -> Bool {
        return line.contains(point)
               && point.x >= minX && point.x <= minX + abs(dx)
               && point.y >= minY && point.y <= minY + abd(dy)
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
        return contains(intersectionPoint) ? intersectionPoint : nil
    }
}

func ==(lhs: Vector, rhs: Vector) -> Bool {
    return lhs.startPoint == rhs.startPoint
           && lhs.endPoint == rhs.endPoint
}
