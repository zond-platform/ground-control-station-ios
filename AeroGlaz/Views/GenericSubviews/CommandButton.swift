//
//  CommandButton.swift
//  Aeroglaz
//
//  Created by Evgeny Agamirzov on 06.05.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum CommandButtonId {
    case importJson
    case upload
    case edit
    case start
    case pause
    case resume
    case stop

    var title: String {
        switch self {
            case .importJson:
                return "Import"
            case .upload:
                return "Upload"
            case .edit:
                return "Edit"
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

extension CommandButtonId : CaseIterable {}

class CommandButton : UIButton {
    var id: CommandButtonId = .upload {
        didSet {
            setTitle(id.title, for: .normal)
        }
    }
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = Colors.Overlay.userLocationColor
            } else {
                backgroundColor = Colors.Text.inactiveTitle
            }
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ id: CommandButtonId) {
        super.init(frame: CGRect())
        self.id = id
        setTitle(id.title, for: .normal)
        titleLabel!.font = Fonts.titleFont
        setTitleColor(Colors.Text.mainTitle, for: .normal)
        backgroundColor = Colors.Text.success
    }
}
