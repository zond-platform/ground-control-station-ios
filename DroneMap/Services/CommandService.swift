//
//  MissionService.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 5/26/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import os.log

import DJISDK

enum MissionCommand {
    case upload
    case start
    case pause
    case resume
    case stop

    var title: String {
        switch self {
            case .upload:
                return "upload"
            case .start:
                return "start"
            case .pause:
                return "pause"
            case .resume:
                return "resume"
            case .stop:
                return "stop"
        }
    }
}

protocol CommandServiceDelegate : AnyObject {
    func missionCommandResponded(_ success: Bool)
}

// Make all protocol methods optional by adding default implementations
extension CommandServiceDelegate {
    func missionCommandResponded(_ success: Bool) {}
}

class CommandService : NSObject {
    var env: Environment
    var currentWaypointIndex: Int?
    var missionOperator: DJIWaypointMissionOperator?
    var delegates: [CommandServiceDelegate?] = []
    
    init(_ env: Environment) {
        self.env = env
        super.init()
        env.productService().addDelegate(self)
    }
}

// Public methods
extension CommandService {
    func addDelegate(_ delegate: CommandServiceDelegate) {
        delegates.append(delegate)
    }

    func setMissionCoordinates(_ coordinates: [CLLocationCoordinate2D]) -> Bool {
        let error = missionOperator?.load(waypointMissionFromCoordinates(coordinates))
        guard error == nil else {
            os_log("Mission load error: %@", type: .error, error!.localizedDescription)
            return false
        }
        return true
    }

    func executeMissionCommand(_ command: MissionCommand) {
        let callback = { (error: Error?) in
            let success = error != nil
            if success {
                os_log("Mission %@ error: %@", type: .error, command.title, error!.localizedDescription)
            } else {
                os_log("Mission %@ succeeded", type: .debug, command.title)
            }
            for delegate in self.delegates {
                delegate?.missionCommandResponded(success)
            }
        }
        switch command {
            case .upload:
                missionOperator?.uploadMission(completion: callback)
            case .start:
                missionOperator?.startMission(completion: callback)
            case .pause:
                missionOperator?.pauseMission(completion: callback)
            case .resume:
                missionOperator?.resumeMission(completion: callback)
            case .stop:
                missionOperator?.stopMission(completion: callback)
        }
    }
}

// Private methods
extension CommandService {
    private func subscribe() {
        // Upload listener
        missionOperator?.addListener(toUploadEvent: self, with: DispatchQueue.main, andBlock: { (event: DJIWaypointMissionUploadEvent) in
            if event.error != nil {
                os_log("Upload listener error: %@", type: .error, event.error!.localizedDescription)
            }
        })

        // Finished listener
        missionOperator?.addListener(toFinished: self, with: DispatchQueue.main, andBlock: { (error: Error?) in
            if error != nil {
                os_log("Finished listener error: %@", type: .error, error!.localizedDescription)
                return
            }
            os_log("Mission finished", type: .debug)
        })

        // Execution listener
        missionOperator?.addListener(toExecutionEvent: self, with: DispatchQueue.main, andBlock: { (event: DJIWaypointMissionExecutionEvent) in
            if event.error != nil {
                os_log("Execution listener error: %@", type: .error, event.error!.localizedDescription)
            } else if let progress = event.progress {
                if self.currentWaypointIndex == nil || self.currentWaypointIndex != progress.targetWaypointIndex {
                    self.currentWaypointIndex = progress.targetWaypointIndex
                    os_log("Heading to waypoint: %@", type: .debug, self.currentWaypointIndex!)
                }
            }
        })
    }

    private func unsubscribe() {
        missionOperator?.removeAllListeners()
    }

    private func getInterruption() {
        missionOperator?.getPreviousInterruption(completion: {
            (interruption: DJIWaypointMissionInterruption?, error: Error?) in
            guard error == nil && interruption != nil else {
                os_log("Interruption error: %@", type: .error, error!.localizedDescription)
                return
            }
            os_log("Mission ID %@ interrupted", type: .debug, interruption!.missionID)
        })
    }

    private func waypointMissionFromCoordinates(_ coordinates: [CLLocationCoordinate2D]) -> DJIWaypointMission {
        let mission = DJIMutableWaypointMission()
        mission.maxFlightSpeed = 15
        mission.autoFlightSpeed = 10
        mission.finishedAction = .goHome
        mission.headingMode = .auto
        mission.flightPathMode = .curved
        mission.rotateGimbalPitch = true
        mission.exitMissionOnRCSignalLost = true
        mission.gotoFirstWaypointMode = .safely
        mission.repeatTimes = 1
        for coordinate in coordinates {
            let waypoint = DJIWaypoint(coordinate: coordinate)
            waypoint.altitude = 100
            waypoint.heading = 0
            waypoint.actionRepeatTimes = 1
            waypoint.actionTimeoutInSeconds = 60
            waypoint.cornerRadiusInMeters = 5
            waypoint.turnMode = .clockwise
            waypoint.gimbalPitch = -90
            waypoint.shootPhotoDistanceInterval = 20
            waypoint.cornerRadiusInMeters = 5
            mission.add(waypoint)
        }
        return DJIWaypointMission(mission: mission)
    }
}

// Comply with generic service protocol
extension CommandService : ServiceProtocol {
    func start() {
        missionOperator = DJISDKManager.missionControl()?.waypointMissionOperator()
        subscribe()
    }

    func stop() {
        missionOperator = nil
        unsubscribe()
    }
}

// Handle vehicle model updates
extension CommandService : ProductServiceDelegate {
    func modelChanged(_ model: String?) {
        if model != nil && model != DJIAircraftModeNameOnlyRemoteController {
            self.start()
        } else {
            self.stop()
        }
    }
}
