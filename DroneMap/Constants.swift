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

    struct Proportion {
        static let vertical: [CGFloat] = [0.09, 0.91]
        static let horizontal: [CGFloat] = [0.4, 0.4, 0.2]
    }

    struct Content {
        private static let marginRate = CGFloat(0.01)
        private static let margin = screenWidth * marginRate

        static let x = margin
        static let y = margin
        static let width = screenWidth - margin * CGFloat(2)
        static let height = screenHeight - margin * CGFloat(2)
    }

    struct Tab {
        static let x = Content.x
        static let y = Content.y
        static let width = Content.width
        static let height = Content.height * Proportion.vertical[0]
    }

    struct Settings {
        static let x = Content.x
        static let y = Content.y + Tab.height
        static let width = Content.width * Proportion.horizontal[0]
        static let height = Content.height * Proportion.vertical[1]
        static let rowHeight = Tab.height

        struct SimulatorSection {
            static let headerHeight = Tab.height * CGFloat(1.5)
            static let footerHeight = CGFloat(0)
        }

        struct EditorSection {
            static let headerHeight = Tab.height * CGFloat(1.5)
            static let footerHeight = CGFloat(0)
        }

        struct StatusSection {
            static let headerHeight = Tab.height * CGFloat(1.5)
            static let footerHeight = Tab.height * CGFloat(0.5)
        }
    }

    struct Console {
        static let width = Content.width * Proportion.horizontal[1]
    }

    struct Controls {
        static let x = Content.x + Settings.width + Console.width
        static let y = Content.y + Tab.height
        static let width = Content.width * Proportion.horizontal[2]
        static let height = Tab.height * CGFloat(ControlButtonId.allCases.count)
    }
}

struct AppColor {
    static let baseColor = UIColor.white

    private struct Alphas {
        static let opaque = CGFloat(1)
        static let semiOpaque = CGFloat(0.9)
        static let semiTransparent = CGFloat(0.9)
        static let transparent = CGFloat(0.4)
    }

    struct Overlay {
        static let opaque = baseColor
        static let semiOpaque = opaque.withAlphaComponent(Alphas.semiOpaque)
        static let semiTransparent = opaque.withAlphaComponent(Alphas.semiTransparent)
        static let transparent = opaque.withAlphaComponent(Alphas.transparent)
    }

    struct Text {
        static let mainTitle = UIColor.black
        static let detailTitle = UIColor.gray
        static let inactiveTitle = UIColor.lightGray
        static let error = UIColor(red: 1.0, green: 0.4, blue: 0.3, alpha: Alphas.opaque)
        static let success = UIColor(red: 0.5, green: 0.7, blue: 0.5, alpha: Alphas.opaque)
    }
}

struct AppFont {
    static let smallFont = UIFont.systemFont(ofSize: 12, weight: .light)
    static let normalLightFont = UIFont.systemFont(ofSize: 14, weight: .light)
    static let normalRegularFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    static let normalBoldFont = UIFont.systemFont(ofSize: 14, weight: .bold)
    static let largeLightFont = UIFont.systemFont(ofSize: 14, weight: .light)
    static let largeRegularFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    static let largeBoldFont = UIFont.systemFont(ofSize: 14, weight: .bold)
}
