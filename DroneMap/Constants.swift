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
        static let width = screenWidth - 2 * margin
        static let height = screenHeight - 2 * margin
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
        static let sectionHeaderHeight = Tab.height
        static let sectionFooterHeight = Tab.height
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
    private struct Alphas {
        static let opaque = CGFloat(1)
        static let semiOpaque = CGFloat(0.9)
        static let semiTransparent = CGFloat(0.8)
        static let transparent = CGFloat(0.3)
    }

    struct Overlay {
        static let white = UIColor.white
        static let semiOpaqueWhite = UIColor.white.withAlphaComponent(Alphas.semiOpaque)
        static let semiTransparentWhite = UIColor.white.withAlphaComponent(Alphas.semiTransparent)
        static let semiOpaqueBlack = UIColor.black.withAlphaComponent(Alphas.semiOpaque)
        static let semiTransparentBlack = UIColor.black.withAlphaComponent(Alphas.semiTransparent)
    }
    
    struct Text {
        static let error = UIColor(red: 1.0, green: 0.4, blue: 0.3, alpha: Alphas.opaque)
        static let success = UIColor(red: 0.5, green: 0.7, blue: 0.5, alpha: Alphas.opaque)
    }
}

struct AppFont {
    static let smallFont = UIFont(name: "Helvetica Light", size: 12)!
    static let normalFont = UIFont(name: "Helvetica Light", size: 14)!
    static let largeFont = UIFont(name: "Helvetica Light", size: 16)!
}
