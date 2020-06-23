//
//  Utils.swift
//  AeroGlaz
//
//  Created by Evgeny Agamirzov on 23.06.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import CoreGraphics

class GeometryUtils {
    static let pi = CGFloat(Double.pi)
    static let eps = CGFloat(10e-6)

    static func isEqual(_ a: CGFloat, _ b: CGFloat) -> Bool {
        return abs(a - b) < eps
    }
}
