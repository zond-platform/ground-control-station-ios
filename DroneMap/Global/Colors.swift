//
//  Colors.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 22.05.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

struct Color {
    private struct Alphas {
        static let opaque = CGFloat(1)
        static let semiOpaque = CGFloat(0.9)
        static let semiTransparent = CGFloat(0.6)
        static let transparent = CGFloat(0.4)
    }

    static let primaryColor = UIColor(red: 0.2588, green: 0.2863, blue: 0.2863, alpha: Alphas.semiOpaque)
    static let secondaryColor = UIColor(red: 0.3647, green: 0.6784, blue: 0.8863, alpha: 1.0)

    struct Text {
        static let mainTitle = UIColor.white
        static let detailTitle = UIColor.lightGray
        static let inactiveTitle = UIColor.gray
        static let error = UIColor(red: 1.0, green: 0.4, blue: 0.3, alpha: Alphas.opaque)
        static let success = UIColor(red: 0.5, green: 0.7, blue: 0.5, alpha: Alphas.opaque)
    }
}
