//
//  ControlButton.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 15.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum NavigationButtonId {
    case simulator
    case user
    case aircraft

    var title: String {
        switch self {
            case .simulator:
                return "Simulator"
            case .user:
                return "User"
            case .aircraft:
                return "Aircraft"
        }
    }
}

extension NavigationButtonId : CaseIterable {}

class NavigationButton : UIButton {
    private(set) var id: NavigationButtonId!

    override var isSelected: Bool {
        didSet {
            if isSelected {
                setTitleColor(AppColor.secondaryColor, for: .normal)
            } else {
                setTitleColor(AppColor.Text.mainTitle, for: .normal)
            }
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ id: NavigationButtonId) {
        self.id = id
        super.init(frame: CGRect())
        setTitle(id.title, for: .normal)
        backgroundColor = AppColor.primaryColor
        titleLabel!.font = AppFont.smallFont
        clipsToBounds = true
    }
}
