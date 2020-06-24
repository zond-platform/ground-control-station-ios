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
    let startPoint: CGPoint
    let endPoint: CGPoint
    let rect: Rect
    let line: Line

    // Create a null vector
    convenience init() {
        self.init(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0))
    }

    // Create an identitiy vector parrallel to the y axis
    convenience init(endPoint: CGPoint) {
        self.init(CGPoint(x: endPoint.x, y: endPoint.y - 1.0), endPoint)
    }

    init(_ startPoint: CGPoint, _ endPoint: CGPoint) {
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.rect = Rect(startPoint, endPoint)
        self.line = Line(angle: rect.dx == 0
                                ? (GeometryUtils.pi / 2)
                                : (rect.dy / rect.dx),
                         point: startPoint)
    }
}

// Public methods
extension Vector {
    func contains(_ point: CGPoint) -> Bool {
        return line.contains(point) && rect.contains(point)
    }

    func intersectionPoint(with vector: Vector) -> CGPoint? {
//        var intersectionPoint = CGPoint()
//        if dx == 0 && vector.dx == 0 {
//            return nil
//        } else if a == vector.a && b != vector.b {
//            return nil
//        } else if a == vector.a && b == vector.b {
//            let x = startPoint.x
//            intersectionPoint = CGPoint(x: x, y: vector.a * x + vector.b)
//        } else if dx == 0 {
//            let x = startPoint.x
//            intersectionPoint = CGPoint(x: x, y: vector.a * x + vector.b)
//        } else if vector.dx == 0 {
//            let x = vector.startPoint.x
//            intersectionPoint = CGPoint(x: x, y: a * x + b)
//        } else {
//            let x = (vector.b - b) / (a - vector.a)
//            intersectionPoint = CGPoint(x: x, y: a * x + b)
//        }
//        return contains(intersectionPoint) ? intersectionPoint : nil
        return nil
    }
}

func ==(lhs: Vector, rhs: Vector) -> Bool {
    return lhs.startPoint == rhs.startPoint
           && lhs.endPoint == rhs.endPoint
}
