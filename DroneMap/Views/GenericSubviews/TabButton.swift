//
//  TabButton.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 18.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum TabButtonId {
    case mission
    case console
    case controls

    var title: String {
        switch self {
            case .mission:
                return "Menu"
            case .console:
                return ">_"
            case .controls:
                return "Controls"
        }
    }

    var width: CGFloat {
        switch self {
            case .mission:
                return AppDimensions.Settings.width
            case .console:
                return AppDimensions.Console.width
            case .controls:
                return AppDimensions.Controls.width
        }
    }
}

extension TabButtonId : CaseIterable {}

class TabButton : UIButton {
    let id: TabButtonId

    required init?(coder: NSCoder) {
        self.id = .mission
        super.init(coder: coder)
    }

    init(_ id: TabButtonId) {
        self.id = id
        super.init(frame: CGRect())
        setTitle(id.title, for: [.normal, .selected])
        setTitleColor(.black, for: [.normal, .selected])
        backgroundColor = AppColor.Overlay.semiOpaqueWhite
        titleLabel!.font = AppFont.largeFont
    }
}
