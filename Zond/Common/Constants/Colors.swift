//
//  Colors.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 22.05.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

struct Colors {
    static let primary   = UIColor(red: 0.15, green: 0.20, blue: 0.22, alpha: 0.8)
    static let secondary = UIColor(red: 0.01, green: 0.61, blue: 0.90, alpha: 1.00)
    static let inactive  = UIColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 1.00)

    static let success   = UIColor(red: 0.30, green: 0.69, blue: 0.31, alpha: 1.00)
    static let warning   = UIColor(red: 1.00, green: 0.92, blue: 0.23, alpha: 1.00)
    static let error     = UIColor(red: 1.00, green: 0.13, blue: 0.13, alpha: 1.00)
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
