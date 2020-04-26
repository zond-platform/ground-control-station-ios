//
//  ConsoleLabel.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 26.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class ConsoleLabel : UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        super.drawText(in: rect.inset(by: insets))
    }
}
