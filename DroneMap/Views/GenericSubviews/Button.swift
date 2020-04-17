//
//  Button.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 15.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum ButtonId {
    case start
    case stop
    case user
    case aircraft

    var title: String {
        switch self {
            case .start:
                return "Start"
            case .stop:
                return "Stop"
            case .user:
                return "User"
            case .aircraft:
                return "Aircraft"
        }
    }
}

extension ButtonId : CaseIterable {}

class Button : UIButton {
    var id: ButtonId!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ id: ButtonId) {
        self.id = id
        super.init(frame: CGRect())
        setTitle(id.title, for: .normal)
        setTitleColor(.black, for: .normal)
        titleLabel!.font = AppFont.smallFont
    }

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        AppColor.OverlayColor.semiOpaqueWhite.setFill()
        path.fill()
    }
}
