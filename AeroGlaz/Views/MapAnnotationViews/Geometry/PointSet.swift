//
//  PointSet.swift
//  AeroGlaz
//
//  Created by Evgeny Agamirzov on 26.06.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import CoreGraphics

class PointSet {
    // Stored properties
    private(set) var points: [CGPoint] = []
    private(set) var hull = Hull()
    private(set) var meander = Meander()

    // Computed properties
    var isComputed: Bool {
        return !points.isEmpty && !hull.points.isEmpty && !meander.points.isEmpty
    }
}

// Public methods
extension PointSet {
    func set(points: [CGPoint]) {
        self.points = points
    }

    func computeHull() {
        hull.compute(points)
    }

    func computeMeander(_ delta: CGFloat, _ tangent: CGFloat?) {
        meander.compute(hull, delta, tangent)
    }
}
