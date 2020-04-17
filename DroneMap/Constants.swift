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
            static let sectionHeaderHeight = CGFloat(40)
            static let sectionFooterHeight = CGFloat(40)
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

struct AppColor {
    private struct Alphas {
        static let opaque = CGFloat(1)
        static let semiOpaque = CGFloat(0.8)
        static let semiTransparent = CGFloat(0.6)
        static let transparent = CGFloat(0.3)
    }

    struct OverlayColor {
        static let semiOpaqueWhite = UIColor.white.withAlphaComponent(Alphas.semiOpaque)
    }
    
    struct TextColor {
        static let error = UIColor(red: 1.0, green: 0.4, blue: 0.3, alpha: Alphas.opaque)
        static let success = UIColor(red: 0.5, green: 0.7, blue: 0.5, alpha: Alphas.opaque)
    }
}

struct AppFont {
    static let smallFont = UIFont(name: "Helvetica Light", size: 12)!
    static let normalFont = UIFont(name: "Helvetica Light", size: 14)!
    static let largeFont = UIFont(name: "Helvetica Light", size: 16)!
}
