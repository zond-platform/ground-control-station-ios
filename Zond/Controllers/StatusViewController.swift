//
//  StatusViewController.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 04.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class StatusViewController : UIViewController {
    private var statusView: StatusView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        statusView = StatusView()
        registerListeners()
        view = statusView
    }
}

// Public methods
extension StatusViewController {
    func triggerMenuButtonSelection(_ select: Bool) {
        statusView.triggerMenuButtonSelection(select)
    }
}

// Private methods
extension StatusViewController {
    private func registerListeners() {
        statusView.menuButtonSelected = { isSelected in
            Environment.missionStateManager.state = isSelected ? .editing : nil
        }
    }
}
