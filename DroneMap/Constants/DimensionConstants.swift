//
//  DimensionConstants.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 16.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import CoreGraphics
import UIKit

struct AppDimensions {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height

    struct SettingsView {
        private static let marginRate = CGFloat(0.02)
        private static let widthRate = CGFloat(0.4)
        private static let divisionRate = CGFloat(0.1)
        private static let margin = AppDimensions.screenWidth * marginRate

        static let x = margin
        static let y = margin
        static let width = AppDimensions.screenWidth * widthRate
        static let height = AppDimensions.screenHeight - margin

        struct Tab {
            static let radius = CGFloat(10)
            static let height = AppDimensions.SettingsView.height * AppDimensions.SettingsView.divisionRate
        }

        struct Table {
            static let height = AppDimensions.SettingsView.height - AppDimensions.SettingsView.Tab.height
        }
    }

    struct ButtonsView {
        private static let widthRate = CGFloat(0.1)

        static let x = AppDimensions.screenWidth - AppDimensions.screenWidth * widthRate
        static let y = CGFloat(0)
        static let width = AppDimensions.screenWidth * widthRate
        static let height = AppDimensions.screenHeight

        struct Button {
            static let size = CGFloat(50)
            static let spacer = CGFloat(30)
        }
    }
}
