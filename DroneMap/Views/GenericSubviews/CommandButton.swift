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
                setTitleColor(AppColor.Text.detailTitle, for: .normal)
                layer.borderColor = AppColor.Text.detailTitle.cgColor
            } else {
                setTitleColor(AppColor.Text.inactiveTitle, for: .normal)
                layer.borderColor = AppColor.Text.inactiveTitle.cgColor
            }
        }
    }

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                setTitleColor(AppColor.secondaryColor, for: .normal)
                layer.borderColor = AppColor.secondaryColor.cgColor
            } else {
                setTitleColor(AppColor.Text.detailTitle, for: .normal)
                layer.borderColor = AppColor.Text.detailTitle.cgColor
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
        titleLabel!.font = AppFont.smallFont
        clipsToBounds = true
        setTitleColor(AppColor.Text.detailTitle, for: .normal)
        layer.borderColor = AppColor.Text.detailTitle.cgColor
        layer.borderWidth = 0.5
    }
}
