//
//  ConsoleLabel.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 26.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class Label : UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(
            top: 0,
            left: Dimensions.textSpacer,
            bottom: 0,
            right: Dimensions.textSpacer
        )
        super.drawText(in: rect.inset(by: insets))
    }
}
