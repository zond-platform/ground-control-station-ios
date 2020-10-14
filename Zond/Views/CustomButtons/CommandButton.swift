//
//  CommandButton.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 11.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum CommandButtonId: Int {
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

    var color: UIColor {
        switch self {
            case .start:
                return Colors.success
            case .pause:
                return Colors.warning
            case .resume:
                return Colors.success
            case .stop:
                return Colors.error
        }
    }
}

extension CommandButtonId : CaseIterable {}

class CommandButton : UIButton {
    // Stored properties
    var id: CommandButtonId? {
        didSet {
            if let id = id {
                setTitle(id.title, for: .normal)
                setTitleColor(id.color, for: .normal)
                titleLabel!.font = Fonts.boldTitle
            }
        }
    }

    // Observer properties
    override var isEnabled: Bool {
        didSet {
            setTitleColor(isEnabled && id != nil ? id!.color : Colors.inactive, for: .normal)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ id: CommandButtonId) {
        super.init(frame: CGRect())
        self.id = id
        backgroundColor = Colors.primary
        layer.cornerRadius = Dimensions.commandButtonDiameter * CGFloat(0.5)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: Dimensions.commandButtonDiameter),
            heightAnchor.constraint(equalToConstant: Dimensions.commandButtonDiameter)
        ])
    }
}
