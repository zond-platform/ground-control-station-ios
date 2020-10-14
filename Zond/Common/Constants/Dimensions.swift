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
    static let tileSize = screenHeight * CGFloat(0.07)
    static let spacer = tileSize * CGFloat(0.25)

    // Status view
    static let simulatorButtonWidth = tileSize * CGFloat(3)
    static let missionMenuWidth = tileSize * CGFloat(10)

    // Command view
    static let commandButtonDiameter = tileSize * CGFloat(2)

    // Telemetry widgets
    static let telemetryIconSize = tileSize * CGFloat(0.5)
    static let telemetrySpacer = tileSize * CGFloat(0.1)
    static let telemetryLabelWidth = tileSize
    static let telemetryIndicatorWidth = tileSize * CGFloat(0.4)
}
