//
//  ControlViewController.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 5/3/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit
import DJISDK

class ControlViewController : UIViewController {
    private var env: Environment!
    private var controlView: ControlView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ env: Environment) {
        super.init(nibName: nil, bundle: nil)
        self.env = env
        self.env.simulatorService().addDelegate(self)
        self.env.connectionService().addDelegate(self)
        self.env.productService().addDelegate(self)
        controlView = ControlView()
        controlView.delegate = self
        view = controlView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// Handle view updates
extension ControlViewController : ControlViewDelegate {
    func simulatorButtonSelected(_ selected: Bool) {
        if selected {
            env.simulatorService().startSimulator(env.mapViewController().userLocation())
        } else {
            env.simulatorService().stopSimulator()
        }
    }

    func restartButtonPressed() {
        env.connectionService().restart()
    }

    func missionEditingMode(_ enabled: Bool) {
        env.mapViewController().enableMissionEditing(enabled)
    }

    func uploadButtonPressed() {
        let coordinates = env.mapViewController().missionCoordinates()
        if !coordinates.isEmpty {
            env.commandService().uploadMission(for: coordinates)
        } else {
            print("nothing to upload")
        }
    }

    func startButtonPressed() {
        env.commandService().startMission()
    }

    func stopButtonPressed() {
        env.commandService().stopMission()
    }

    func pauseButtonPressed() {
        env.commandService().pauseMission()
    }

    func resumeButtonPressed() {
        env.commandService().resumeMission()
    }
}

// Handle model updates
extension ControlViewController : ProductServiceDelegate {
    func modelChanged(_ model: String) {
        if model == DJIAircraftModeNameOnlyRemoteController {
            controlView.onSimulatorResponse(false)
        }
    }
}

// Handle connection updates
extension ControlViewController : ConnectionServiceDelegate {
    func statusChanged(_ status: ConnectionStatus) {
        if status == .disconnected {
            controlView.onSimulatorResponse(false)
        } else {
            controlView.onConnectionEstablished()
        }
    }
}

// Handle simulator response
extension ControlViewController : SimulatorServiceDelegate {
    func commandResponded(_ success: Bool) {
        controlView.onSimulatorResponse(success)
    }
}
