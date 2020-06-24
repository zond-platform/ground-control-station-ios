//
//  Rect.swift
//  AeroGlaz
//
//  Created by Evgeny Agamirzov on 25.06.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import CoreGraphics

class Rect : Equatable {
    // Stored properties
    let dx: CGFloat
    let dy: CGFloat
    let minX: CGFloat
    let minY: CGFloat

    init(_ startPoint: CGPoint, _ endPoint: CGPoint) {
        self.dx = endPoint.x - startPoint.x
        self.dy = endPoint.y - startPoint.y
        self.minX = endPoint.x > startPoint.x ? startPoint.x : endPoint.x
        self.minY = endPoint.y > startPoint.y ? startPoint.y : endPoint.y
    }
}

// Public methods
extension Rect {
    func contains(_ point: CGPoint) -> Bool {
        return point.x >= minX && point.x <= minX + abs(dx)
               && point.y >= minY && point.y <= minY + abs(dy)
    }
}

func ==(lhs: Rect, rhs: Rect) -> Bool {
    return lhs.dx == rhs.dx
           && lhs.dy == rhs.dy
           && lhs.minX == rhs.minX
           && lhs.minY == rhs.minY
}
