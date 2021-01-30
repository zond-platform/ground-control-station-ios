//
//  CommandViewController.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 08.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import os.log

import UIKit

class CommandViewController : UIViewController {
    private var commandView: CommandView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        commandView = CommandView()
        registerListeners()
        view = commandView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// Private methods
extension CommandViewController {
    private func registerListeners() {
        commandView.buttonPressed = { id in
            switch id {
                case .start:
                    Environment.commandService.executeMissionCommand(.start)
                case .pause:
                    Environment.commandService.executeMissionCommand(.pause)
                case .resume:
                    Environment.commandService.executeMissionCommand(.resume)
                case .stop:
                    Environment.commandService.executeMissionCommand(.stop)
                default:
                    break
            }
        }
        Environment.commandService.commandResponseListeners.append({ id, success in
            if success {
                switch id {
//                    case .start:
//                        Environment.missionStateManager.state = .running
//                    case .pause:
//                        Environment.missionStateManager.state = .paused
//                    case .resume:
//                        Environment.missionStateManager.state = .running
                    case .stop:
                        Environment.missionStorage.dropActiveMission()
                        Environment.missionStateManager.state = .none
                    default:
                        break
                }
            }
        })
        Environment.commandService.missionFinished = { success in
            Environment.missionStateManager.state = .none
            Environment.missionStorage.dropActiveMission()
        }
        Environment.missionStateManager.stateListeners.append({ newState in
            if newState != .none && newState != .editing {
                self.commandView.setControls(for: newState)
                self.toggleShowView(show: true, delay: Animations.defaultDelay)
            } else {
                self.toggleShowView(show: false, delay: 0)
            }
        })
    }

    private func toggleShowView(show: Bool, delay: TimeInterval) {
        if show {
            self.commandView.isHidden = false
        }
        UIView.animate(
            withDuration: Animations.defaultDuration,
            delay: delay,
            options: [],
            animations: {
                self.commandView.toggleShow(show)
            },
            completion: { _ in
                if !show {
                    self.commandView.isHidden = true
                }
            }
        )
    }
}
