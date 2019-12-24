//
//  Vector.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 24.12.19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import CoreGraphics

class Vector : Equatable {
    public let startPoint, endPoint: CGPoint
    public let dx, dy: CGFloat
    public let minY, maxY: CGFloat
    
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
        
        self.dx = endPoint.x - startPoint.x
        self.dy = endPoint.y - startPoint.y
        
        let comparison = endPoint.y > startPoint.y
        self.minY = comparison ? startPoint.y : endPoint.y
        self.maxY = comparison ? endPoint.y : startPoint.y
    }
}

// Public functions
extension Vector {
    // Find an intersection point between a vector and the provided y value
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
    return lhs.startPoint == rhs.startPoint
           && lhs.endPoint == rhs.endPoint
}
