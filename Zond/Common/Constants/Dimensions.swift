//
//  Dimensions.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 22.05.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import DeviceGuru
import UIKit

struct Dimensions {
    // Absolute bounds
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height

    // Generic anchor sizes
    static let tileSize = screenHeight * CGFloat(0.08)
    static let separator = CGFloat(1)
    static let spacer = tileSize * CGFloat(0.25)
    static let doubleSpacer = tileSize * CGFloat(0.5)
    static let roundedAreaOffset = tileSize * CGFloat(1.2)

    // View sizes
    static let missionMenuWidth = roundedAreaOffsetOr(0) + tileSize * CGFloat(7)
    static let dynamicTelemetryWidgetWidth = tileSize * CGFloat(3)
    static let dynamicTelemetryWidgetHeight = tileSize
    static let commandButtonDiameter = tileSize * CGFloat(2)

    // Telemetry widgets
    static let telemetryIconSize = tileSize * CGFloat(0.5)
    static let telemetrySpacer = tileSize * CGFloat(0.1)
    static let staticTelemetryLabelWidth = tileSize
    static let telemetryIndicatorWidth = tileSize * CGFloat(0.4)

    // Device info
    static var isPhoneWithRoundedCorners: Bool {
        let deviceGuru = DeviceGuru()
        return deviceGuru.platform() == .iPhone &&
               deviceGuru.deviceVersion() != nil &&
               deviceGuru.deviceVersion()! > DeviceVersion(major: 10, minor: 3)
    }
    static func roundedAreaOffsetOr(_ value: CGFloat) -> CGFloat {
        return Dimensions.isPhoneWithRoundedCorners ? roundedAreaOffset : value
    }
}
