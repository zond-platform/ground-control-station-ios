//
//  MissionViewController.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 4/6/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import os.log

import UIKit

class MissionViewController : UIViewController {
    // Stored properties
    private var missionView: MissionView!

    // Notifyer properties
    var logConsole: ((_ message: String, _ type: OSLogType) -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        missionView = MissionView()
        registerListeners()
        view = missionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// Private methods
extension MissionViewController {
    private func registerListeners() {
        missionView.cancelButtonPressed = {
            Environment.missionStateManager.state = .none
        }
        Environment.commandService.commandResponseListeners.append({ id, success in
            if success && id == .upload {
//                Environment.missionStateManager.state = .uploaded
//                Environment.missionStorage.writeActiveMission()
            }
        })
        Environment.missionStateManager.stateListeners.append({ newState in
            if newState == .editing {
                self.toggleShowView(show: true, delay: Animations.defaultDelay)
            } else {
                self.toggleShowView(show: false, delay: 0)
            }
        })
        Environment.connectionService.listeners.append({ [self] model in
            if model != nil && Environment.missionStorage.activeMissionPresent() {
//                Environment.missionStorage.readActiveMission()
//                switch Environment.commandService.activeExecutionState {
//                    case .readyToExecute:
//                        Environment.missionStateManager.state = .uploaded
//                    case .executing:
//                        Environment.missionStateManager.state = .running
//                    case .executionPaused:
//                        Environment.missionStateManager.state = .paused
//                    case .unknown:
//                        break
//                    default:
//                        logConsole?("Discarding active mission. Inactive execution state.", .debug)
//                        Environment.missionStorage.dropActiveMission()
//                        break
//                }
            }
        })
    }

    private func toggleShowView(show: Bool, delay: TimeInterval) {
        UIView.animate(
            withDuration: Animations.defaultDuration,
            delay: delay,
            options: [],
            animations: {
                self.missionView.toggleShowFromSide(show)
            }
        )
    }
}
