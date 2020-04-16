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
    private let buttonSize = CGFloat(50)

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(_ id: ButtonId) {
        self.id = id
        super.init(frame: CGRect())
        setTitle(id.title, for: .normal)
        setTitleColor(.gray, for: .normal)
        titleLabel!.font = UIFont(name: "Helvetica Light", size: 12)!
        heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
    }

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        UIColor(white: 1.0, alpha: 0.6).setFill()
        path.fill()
    }
}
