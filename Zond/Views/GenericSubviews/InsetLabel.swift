//
//  ConsoleLabel.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 26.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class InsetLabel : UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(
            top: 0,
            left: Dimensions.spacer,
            bottom: 0,
            right: 0
        )
        super.drawText(in: rect.inset(by: insets))
    }
}
