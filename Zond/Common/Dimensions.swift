//
//  Dimensions.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 22.05.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

struct Dimensions {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let viewSpacer = screenWidth * CGFloat(0.01)
    static let textSpacer = screenWidth * CGFloat(0.015)

    struct ContentView {
        struct Ratio {
            static let h: [CGFloat] = [0.4, 0.45, 0.15]
            static let v: [CGFloat] = [0.09, 0.91]
        }
        static let x = viewSpacer
        static let y = viewSpacer
        static let width = screenWidth - viewSpacer * CGFloat(2.0)
        static let height = screenHeight - viewSpacer * CGFloat(2.0)
        static let spacer = viewSpacer
    }
}
