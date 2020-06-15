//
//  StatusLabel.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 23.05.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class StatusLabel : InsetLabel {
    private(set) var id: TelemetryDataId!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ id: TelemetryDataId) {
        self.id = id
        super.init(frame: CGRect())
        font = Fonts.telemetryFont
        textColor = Colors.Text.mainTitle
        layer.shadowColor = Colors.Overlay.primaryColor.cgColor
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.masksToBounds = false
    }
}

// Public methods
extension StatusLabel {
    func updateText(_ temetryData: String?) {
        text = (temetryData ?? id.defaultValue) + " " + id.unit
    }
}
