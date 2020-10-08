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
            }
        }
        Environment.commandService.commandResponded = { id, success in
            if success {
                switch id {
                    case .start:
                        Environment.missionViewController.setMissionState(.running)
                    case .pause:
                        Environment.missionViewController.setMissionState(.paused)
                    case .resume:
                        Environment.missionViewController.setMissionState(.running)
                    case .stop:
                        Environment.missionViewController.setMissionState(.editing)
                    default:
                        break
                }
            }
        }
        Environment.commandService.missionFinished = { success in
            Environment.missionViewController.setMissionState(nil)
        }
        Environment.missionViewController.stateListeners.append({ state in
            self.commandView.showFromSide(state == nil || state! == .editing ? false : true)
        })
    }
}
