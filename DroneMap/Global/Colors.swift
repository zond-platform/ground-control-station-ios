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
        static let semiOpaque = CGFloat(0.8)
        static let semiTransparent = CGFloat(0.6)
        static let transparent = CGFloat(0.4)
    }

    struct Overlay {
        static let primaryColor = UIColor(red: 0.2588, green: 0.2863, blue: 0.2863, alpha: Alphas.semiOpaque)
        static let selectedColor = UIColor(red: 0.2588, green: 0.2863, blue: 0.2863, alpha: Alphas.opaque)
        static let simulatorActiveColor = UIColor(red: 0.1529, green: 0.6824, blue: 0.3765, alpha: Alphas.opaque)
        static let userLocationColor = UIColor(red: 0.2039, green: 0.5961, blue: 0.8588, alpha: Alphas.opaque)
        static let aircraftLocationColor = UIColor(red: 0.8275, green: 0.3294, blue: 0, alpha: Alphas.opaque)
    }

    struct Text {
        static let mainTitle = UIColor.white
        static let detailTitle = UIColor.lightGray
        static let inactiveTitle = UIColor.gray
        static let selectedTitle = UIColor(red: 0.3647, green: 0.6784, blue: 0.8863, alpha: 1.0)
        static let error = UIColor(red: 1.0, green: 0.4, blue: 0.3, alpha: Alphas.opaque)
        static let success = UIColor(red: 0.5, green: 0.7, blue: 0.5, alpha: Alphas.opaque)
    }
}

extension UIImage {
    func color(_ color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            self.draw(at: .zero)
            context.fill(CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height), blendMode: .sourceAtop)
        }
    }
}
