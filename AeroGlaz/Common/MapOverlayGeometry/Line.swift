//
//  Line.swift
//  AeroGlaz
//
//  Created by Evgeny Agamirzov on 23.06.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import CoreGraphics

enum IntersectionError : Error {
    case parallel
    case overlap
}

class Line : Equatable {
    let a: CGFloat?
    private(set) var b: CGFloat?
    private(set) var x: CGFloat?

    // Create line from tangent and reference point
    convenience init(tangent: CGFloat?, point: CGPoint) {
        if tangent == nil {
            self.init(a: nil, b: nil, x: point.x)
        } else {
            self.init(a: tangent!, b: point.y - tangent! * point.x)
        }
    }

    // Create vertical line
    convenience init(x: CGFloat) {
        self.init(a: nil, b: nil, x: x)
    }

    // Create line from coefficients
    init(a: CGFloat?, b: CGFloat?, x: CGFloat? = nil) {
        self.a = a
        self.b = b
        self.x = x
    }
}

// Public methods
extension Line {
    func contains(_ point: CGPoint) -> Bool {
        // Use formula from the initializer. Otherwise, scrambling of the parameters
        // may lead to incorrect calculations because of the floating point precision
        // issues and the reference point from which the line was created might be
        // considered to be off the line.
        return x == nil ? (point.y - a! * point.x - b! == 0) : (x! == point.x)
    }

    func move(for normalDistance: CGFloat) {
        if x == nil {
            b! += normalDistance / cos(atan(a!))
        } else {
            x! += normalDistance
        }
    }

    func intersectionPoint(with line: Line) -> Result<CGPoint, IntersectionError> {
        // Both lines vertical
        if x != nil && line.x != nil {
            if x! == line.x! {
                return .failure(.overlap)
            } else {
                return .failure(.parallel)
            }
        }
        // First line vertical
        else if x != nil {
            return .success(CGPoint(x: x!, y: line.a! * x! + line.b!))
        }
        // Second line vertical
        else if line.x != nil {
            return .success(CGPoint(x: line.x!, y: a! * line.x! + b!))
        }
        // Lines have same tangent
        else if a == line.a {
            if b == line.b {
                return .failure(.overlap)
            } else {
                return .failure(.parallel)
            }
        }
        // Generic case
        else {
            let x = (line.b! - b!) / (a! - line.a!)
            return .success(CGPoint(x: x, y: a! * x + b!))
        }
    }
}

func ==(lhs: Line, rhs: Line) -> Bool {
    return lhs.a == rhs.a
           && lhs.b == rhs.b
           && lhs.x == rhs.x
}
