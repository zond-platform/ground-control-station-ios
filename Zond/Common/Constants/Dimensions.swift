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

    // Building block size
    static let tileSize = screenHeight * CGFloat(0.07)

    // Anchor sizes
    static let spacer = tileSize * CGFloat(0.25)
    static let staticTelemetryWidth = tileSize * CGFloat(8)
    static let simulatorButtonWidth = tileSize * CGFloat(3)
    static let commandButtonDiameter = tileSize * CGFloat(2)
    static let missionMenuWidth = tileSize * CGFloat(10)
}
