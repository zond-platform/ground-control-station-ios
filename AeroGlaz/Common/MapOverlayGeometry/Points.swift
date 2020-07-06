//
//  Points.swift
//  AeroGlaz
//
//  Created by Evgeny Agamirzov on 26.06.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import CoreGraphics

class Points {
    var points: [CGPoint] = []
    private(set) var rect = Rect()
    private(set) var hull = Hull()
    private(set) var meander = Meander()
}

// Public methods
extension Points {
    func recomputeShapes(_ delta: CGFloat, _ tangent: CGFloat?) {
        rect.compute(points)
        hull.compute(points)
        meander.compute(hull, delta, tangent)
    }
}
