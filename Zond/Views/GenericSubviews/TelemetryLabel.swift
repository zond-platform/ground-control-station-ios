//
//  StaticTelemetryLabel.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 23.05.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class TelemetryLabel : InsetLabel {
    private(set) var id: TelemetryDataId!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ id: TelemetryDataId) {
        self.id = id
        super.init(frame: CGRect())
        font = Fonts.title
        textColor = UIColor.white
    }
}

// Public methods
extension TelemetryLabel {
    func updateText(_ teletryValue: String?) {
        text = id.name + ": " + (teletryValue == nil ? "-" : teletryValue! + " " + id.unit)
    }
}
