//
//  Vector.swift
//  Aeroglaz
//
//  Created by Evgeny Agamirzov on 24.12.19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import CoreGraphics

class Vector : Equatable {
    let startPoint: CGPoint
    let endPoint: CGPoint
    let span: Span
    let line: Line
    let norm: CGFloat

    // Create null vector
    convenience init(at point: CGPoint = CGPoint(x: 0, y: 0)) {
        self.init(point, point)
    }

    // Create identitiy vector parrallel to y axis
    convenience init(endPoint: CGPoint) {
        self.init(CGPoint(x: endPoint.x, y: endPoint.y - 1.0), endPoint)
    }

    init(_ startPoint: CGPoint, _ endPoint: CGPoint) {
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.span = Span(startPoint, endPoint)
        if span.dx == 0 {
            self.line = Line(x: startPoint.x)
        } else {
            let tangent = span.dy / span.dx
            self.line = Line(tangent: tangent, point: endPoint)
        }
        self.norm = sqrt(pow(self.span.dx, 2) + pow(self.span.dy, 2))
    }
}

// Public methods
extension Vector {
    func dot(_ v: Vector) -> CGFloat {
        return self.span.dx * v.span.dx + self.span.dy * v.span.dy
    }

    func theta(_ v: Vector) -> CGFloat {
        return acos(self.dot(v) / (self.norm * v.norm))
    }

    func intersectionPoint(with line: Line) -> [CGPoint] {
        // Need explicit checks if vector points belong the line. Otherwise
        // vector span may not contain the intersection  point on the edge
        // of the vector because of the floating point precision issues
        // (line created from vector is always sligtly off).
        if line.contains(self.startPoint) && line.contains(self.endPoint) {
            return [self.startPoint, self.endPoint]
        } else if line.contains(self.startPoint) {
            return [self.startPoint]
        } else if line.contains(self.endPoint) {
            return [self.endPoint]
        } else {
            switch self.line.intersectionPoint(with: line) {
                case .success(let point):
                    return self.span.contains(point) ? [point] : []
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
