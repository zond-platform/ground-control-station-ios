//
//  ControlButton.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 15.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum ControlButtonId {
    case start
    case pause
    case resume
    case stop

    var title: String {
        switch self {
            case .start:
                return "Start"
            case .pause:
                return "Pause"
            case .resume:
                return "Resume"
            case .stop:
                return "Stop"
        }
    }
}

extension ControlButtonId : CaseIterable {}

class ControlButton : UIButton {
    let id: ControlButtonId

    required init?(coder: NSCoder) {
        self.id = .start
        super.init(coder: coder)
    }

    init(_ id: ControlButtonId) {
        self.id = id
        super.init(frame: CGRect())
        setTitle(id.title, for: .normal)
        setTitleColor(.black, for: .normal)
        backgroundColor = AppColor.Overlay.semiTransparentWhite
        titleLabel!.font = AppFont.smallFont
        clipsToBounds = true
    }
}
