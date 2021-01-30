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

// Private methods
extension StatusViewController {
    private func registerListeners() {
        statusView.menuButtonPressed = {
            Environment.missionStateManager.state = .editing
        }
        Environment.missionStateManager.stateListeners.append({ _, newState in
            if newState == .editing {
                self.toggleShowView(show: false, delay: 0)
            } else {
                self.toggleShowView(show: true, delay: Animations.defaultDelay)
            }
            self.statusView.enableMenuButton(newState == .none || newState == .editing || newState == .uploaded)
        })
    }

    private func toggleShowView(show: Bool, delay: TimeInterval) {
        if show {
            self.statusView.isHidden = false
        }
        UIView.animate(
            withDuration: Animations.defaultDuration,
            delay: delay,
            options: [],
            animations: {
                self.statusView.toggleShowFromTop(show)
            },
            completion: { _ in
                if !show {
                    self.statusView.isHidden = true
                }
            }
        )
    }
}
