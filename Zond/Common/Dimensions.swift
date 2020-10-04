//
//  Dimensions.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 22.05.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

struct Dimensions {
    // Absolute bounds
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height

    // Anchor sizes
    static let viewDivider = CGFloat(0.5)
    static let textSpacer = screenWidth * CGFloat(0.015)
    static let tileSize = screenHeight * CGFloat(0.08)
    static let consoleWidth = screenWidth * CGFloat(0.6)
    static let missionMenuWidth = screenWidth * CGFloat(0.4)

    struct ContentView {
        struct Ratio {
            static let h: [CGFloat] = [0.4, 0.45, 0.15]
            static let v: [CGFloat] = [0.09, 0.91]
        }
        static let x = CGFloat(0.0)
        static let y = CGFloat(0.0)
        static let width = screenWidth
        static let height = screenHeight
    }
}
