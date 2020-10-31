//
//  DynamicTelemetryLabel.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 28.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class DynamicTelemetryLabel : UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect())
        font = Fonts.telemetry
        textColor = UIColor.white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.masksToBounds = false
    }
}
