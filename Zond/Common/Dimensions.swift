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
    static let spacer = screenWidth * CGFloat(0.015)
    static let tileSize = screenHeight * CGFloat(0.07)
    static let staticTelemetryWidth = screenWidth * CGFloat(0.32)
    static let simulatorButtonWidth = screenWidth * CGFloat(0.12)
    static let missionMenuWidth = screenWidth * CGFloat(0.4)
}
