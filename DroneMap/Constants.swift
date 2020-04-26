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
    static let margin = screenWidth * CGFloat(0.01)

    struct Proportion {
        static let horizontal: [CGFloat] = [0.4, 0.2, 0.4]
        static let vertical: [CGFloat] = [0.08, 0.84, 0.08]
    }

    struct Content {
        static let x = margin
        static let y = margin
        static let width = screenWidth - margin * CGFloat(2)
        static let height = screenHeight - margin * CGFloat(2)
    }

    struct Settings {
        static let x = Content.x
        static let y = Content.y
        static let width = Content.width * Proportion.horizontal[0]
        static let height = Content.height * (Proportion.vertical[0] + Proportion.vertical[1]) - margin

        // Button related dimensions
        static let buttonHeight = Content.height * Proportion.vertical[0]
        static let tableHeight = height - buttonHeight

        // Table view related dimensions
        static let rowHeight = Content.height * Proportion.vertical[0]
        struct SimulatorSection {
            static let headerHeight = rowHeight * CGFloat(1.5)
            static let footerHeight = CGFloat(0)
        }
        struct EditorSection {
            static let headerHeight = rowHeight * CGFloat(1.5)
            static let footerHeight = CGFloat(0)
        }
        struct StatusSection {
            static let headerHeight = rowHeight * CGFloat(1.5)
            static let footerHeight = rowHeight * CGFloat(0.5)
        }
    }

    struct Controls {
        static let x = Content.x + Content.width * (Proportion.horizontal[0] + Proportion.horizontal[1])
        static let y = Content.y
        static let width = Content.width * Proportion.horizontal[2]
        static let height = Content.height * Proportion.vertical[0]
    }

    struct Console {
        static let x = Content.x
        static let y = Content.y + Content.height * (Proportion.vertical[0] + Proportion.vertical[1])
        static let width = Content.width
        static let height = Content.height * Proportion.vertical[2]
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
