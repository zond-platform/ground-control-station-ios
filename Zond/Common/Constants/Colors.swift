//
//  Colors.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 22.05.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

struct Colors {
    private struct Alphas {
        static let opaque = CGFloat(1)
        static let semiOpaque = CGFloat(0.9)
        static let semiTransparent = CGFloat(0.6)
        static let transparent = CGFloat(0.4)
    }

    static let primary = UIColor(hex: "#263238EE")
    static let primaryTransparent = UIColor(hex: "#263238AA")
    static let secondary = UIColor(hex: "#039BE5FF")
    static let inactive = UIColor(hex: "#9E9E9EFF")

    static let success = UIColor(hex: "#4CAF50FF")
    static let warning = UIColor(hex: "#FFEB3BFF")
    static let error = UIColor(hex: "#FF5722FF")

    static let user = secondary
    static let aircraft = UIColor(hex: "#F57F17FF")
}

extension UIImage {
    func color(_ color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            self.draw(at: .zero)
            context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height), blendMode: .sourceAtop)
        }
    }
}

extension UIColor {
    public convenience init(hex: String) {
        var hexNumber: UInt64 = 0
        let hexColor = String(hex[hex.index(hex.startIndex, offsetBy: 1)...])

        assert(hex.hasPrefix("#"), "Hex color has no # prefix")
        assert(hexColor.count == 8, "Hex color has incorrect number of symbols")
        assert(Scanner(string: hexColor).scanHexInt64(&hexNumber), "Failed to scan hex color string")

        let r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
        let g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
        let b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
        let a = CGFloat(hexNumber & 0x000000ff) / 255

        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
