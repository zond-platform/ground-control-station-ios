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
            self.line = Line(tangent: tangent, point: endPoint)
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

    func intersectionPoint(with line: Line) -> [CGPoint] {
        if line.contains(self.startPoint) && line.contains(self.endPoint) {
            return [self.startPoint, self.endPoint]
        } else if line.contains(self.startPoint) {
            return [self.startPoint]
        } else if line.contains(self.endPoint) {
            return [self.endPoint]
        } else {
            switch self.line.intersectionPoint(with: line) {
                case .success(let point):
                    return self.rect.contains(point) ? [point] : []
                case .failure(let error):
                    return error == .parallel ? [] : [self.startPoint, self.endPoint]
            }
        }
    }
}

func ==(lhs: Vector, rhs: Vector) -> Bool {
    return lhs.startPoint == rhs.startPoint
           && lhs.endPoint == rhs.endPoint
}
