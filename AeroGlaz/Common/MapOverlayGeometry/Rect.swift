//
//  Rect.swift
//  AeroGlaz
//
//  Created by Evgeny Agamirzov on 06.07.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import CoreGraphics

class Rect : Equatable {
    // Stored properties
    private(set) var rect = CGRect()

    // Computed properties
    var minX: CGFloat {
        rect.minX
    }
    var minY: CGFloat {
        rect.minX
    }
    var maxX: CGFloat {
        rect.maxX
    }
    var maxY: CGFloat {
        rect.maxX
    }
}

// Public methods
extension Rect {
    // Jarvis algorithm (gift wrapping)
    func compute(_ rawPoints: [CGPoint]) {
        if !rawPoints.isEmpty {
            let minX = rawPoints.min{ left, right in left.x < right.x }!.x
            let minY = rawPoints.min{ left, right in left.y < right.y }!.y
            let width = abs(rawPoints.max{ left, right in left.x < right.x }!.x - minX)
            let height = abs(rawPoints.max{ left, right in left.y < right.y }!.y - minY)
            rect = CGRect(x: minX, y: minY, width: width, height: height)
        }
    }
}

func ==(lhs: Rect, rhs: Rect) -> Bool {
    return lhs.rect == rhs.rect
}
