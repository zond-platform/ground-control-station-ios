//
//  Span.swift
//  AeroGlaz
//
//  Created by Evgeny Agamirzov on 25.06.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import CoreGraphics

class Span : Equatable {
    let dx: CGFloat
    let dy: CGFloat
    let minX: CGFloat
    let minY: CGFloat
    let center: CGPoint

    // Span from two points (negative dx, dy are possible)
    init(_ startPoint: CGPoint, _ endPoint: CGPoint) {
        self.dx = endPoint.x - startPoint.x
        self.dy = endPoint.y - startPoint.y
        self.minX = endPoint.x > startPoint.x ? startPoint.x : endPoint.x
        self.minY = endPoint.y > startPoint.y ? startPoint.y : endPoint.y
        self.center = CGPoint(x: minX + abs(dx) / 2, y: minY + abs(dy) / 2)
    }
}

// Public methods
extension Span {
    func contains(_ point: CGPoint) -> Bool {
        return point.x >= minX && point.x <= minX + abs(dx)
               && point.y >= minY && point.y <= minY + abs(dy)
    }
}

func ==(lhs: Span, rhs: Span) -> Bool {
    return lhs.dx == rhs.dx
           && lhs.dy == rhs.dy
           && lhs.minX == rhs.minX
           && lhs.minY == rhs.minY
}
