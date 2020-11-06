//
//  Colors.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 22.05.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

struct Colors {
    static let primary   = UIColor(hex: "#263238DD")
    static let secondary = UIColor(hex: "#039BE5FF")
    static let inactive  = UIColor(hex: "#535353FF")

    static let success   = UIColor(hex: "#4CAF50FF")
    static let warning   = UIColor(hex: "#FFEB3BFF")
    static let error     = UIColor(hex: "#FF2222FF")
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

        assert(hex.hasPrefix("#"))
        assert(hexColor.count == 8)
        assert(Scanner(string: hexColor).scanHexInt64(&hexNumber))

        let r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
        let g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
        let b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
        let a = CGFloat(hexNumber & 0x000000ff) / 255

        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
