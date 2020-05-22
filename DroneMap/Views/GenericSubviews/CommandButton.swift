//
//  CommandButton.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 06.05.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum CommandButtonId {
    case upload
    case edit
    case start
    case pause
    case resume
    case stop

    var title: String {
        switch self {
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
                setTitleColor(Color.Text.detailTitle, for: .normal)
                layer.borderColor = Color.Text.detailTitle.cgColor
            } else {
                setTitleColor(Color.Text.inactiveTitle, for: .normal)
                layer.borderColor = Color.Text.inactiveTitle.cgColor
            }
        }
    }
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                setTitleColor(Color.Text.mainTitle, for: .normal)
                layer.borderColor = Color.Text.mainTitle.cgColor
            } else {
                setTitleColor(Color.Text.detailTitle, for: .normal)
                layer.borderColor = Color.Text.detailTitle.cgColor
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
        backgroundColor = .clear
        titleLabel!.font = Font.titleFont
        clipsToBounds = true
        setTitleColor(Color.Text.detailTitle, for: .normal)
        layer.borderColor = Color.Text.detailTitle.cgColor
        layer.borderWidth = 0.5
    }
}
