//
//  ControlButton.swift
//  Aeroglaz
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
    // Stored properties
    private(set) var id: NavigationButtonId!

    // Observer properties
    override var isSelected: Bool {
        didSet {
            if isSelected {
                switch self.id {
                    case .simulator:
                        backgroundColor = Colors.Overlay.simulatorActiveColor
                    case .user:
                        backgroundColor = Colors.Overlay.userLocationColor
                    case .aircraft:
                        backgroundColor = Colors.Overlay.aircraftLocationColor
                    default:
                        break
                }
            } else {
                backgroundColor = Colors.Overlay.primaryColor
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
        backgroundColor = Colors.Overlay.primaryColor
        titleLabel!.font = Fonts.titleFont
        clipsToBounds = true
    }
}
