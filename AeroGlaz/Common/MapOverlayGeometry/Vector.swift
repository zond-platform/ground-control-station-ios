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
    let norm: CGFloat

    // Create null vector
    convenience init() {
        self.init(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0))
    }

    // Create identitiy vector parrallel to y axis
    convenience init(endPoint: CGPoint) {
        self.init(CGPoint(x: endPoint.x, y: endPoint.y - 1.0), endPoint)
    }

    init(_ startPoint: CGPoint, _ endPoint: CGPoint) {
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.rect = Rect(startPoint, endPoint)
        if rect.dx == 0 {
            self.line = Line(x: startPoint.x)
        } else {
            let tangent = rect.dy / rect.dx
            self.line = Line(a: tangent, b: startPoint.y - tangent * startPoint.x)
        }
        self.norm = sqrt(pow(self.rect.dx, 2) + pow(self.rect.dy, 2))
    }
}

// Public methods
extension Vector {
    func dot(_ v: Vector) -> CGFloat {
        return self.rect.dx * v.rect.dx + self.rect.dy * v.rect.dy
    }

    func theta(_ v: Vector) -> CGFloat {
        return acos(self.dot(v) / (self.norm * v.norm))
    }

    func contains(_ point: CGPoint) -> Bool {
        return line.contains(point) && rect.contains(point)
    }

    func intersectionPoint(with line: Line) -> CGPoint? {
        switch self.line.intersectionPoint(with: line) {
            case .success(let point):
                return contains(point) ? point : nil
            case .failure(let error):
                return error == .parallel ? nil : rect.center
        }
    }
}

func ==(lhs: Vector, rhs: Vector) -> Bool {
    return lhs.startPoint == rhs.startPoint
           && lhs.endPoint == rhs.endPoint
}
