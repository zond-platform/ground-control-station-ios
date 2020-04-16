//
//  ColorConstants.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 16.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import CoreGraphics
import UIKit

struct AppColor {
    private struct Alphas {
        static let opaque = CGFloat(1)
        static let semiOpaque = CGFloat(0.8)
        static let semiTransparent = CGFloat(0.6)
        static let transparent = CGFloat(0.3)
    }

    struct OverlayColor {
        static let semiOpaqueWhite = UIColor.white.withAlphaComponent(Alphas.semiOpaque)
        static let semiTransparentWhite = UIColor.white.withAlphaComponent(Alphas.semiTransparent)
    }
}
