//
//  MissionService.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 5/26/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import DJISDK

class CommandService : NSObject {
    var env: Environment
    var currentWaypointIndex: Int?
    var missionOperator: DJIWaypointMissionOperator?
    
    init(_ env: Environment) {
        self.env = env
        super.init()
        env.productService().addDelegate(self)
    }
}

// Public methods
extension CommandService {
    func uploadMission(for coordinates: [CLLocationCoordinate2D]) {
        let error = missionOperator?.load(waypointMissionFromCoordinates(coordinates))
        guard error == nil else {
            env.logger.logError("Mission load error:" + String(describing: error!.localizedDescription), .command, sendToConsole: true)
            return
        }
        missionOperator?.uploadMission(completion: { (error: Error?) in
            if error != nil {
                self.env.logger.logError("Mission upload error:" + String(describing: error!.localizedDescription), .command, sendToConsole: true)
            } else {
                self.env.logger.logDebug("Mission uploaded", .command, sendToConsole: true)
            }
        })
    }

    func startMission() {
        missionOperator?.startMission(completion: { (error: Error?) in
            if error != nil {
                self.env.logger.logError("Mission start error:" + String(describing: error!.localizedDescription), .command, sendToConsole: true)
            } else {
                self.env.logger.logDebug("Mission started", .command, sendToConsole: true)
            }
        })
    }

    func pauseMission() {
        missionOperator?.pauseMission(completion: { (error: Error?) in
            if error != nil {
                self.env.logger.logError("Mission pause error:" + String(describing: error!.localizedDescription), .command, sendToConsole: true)
            } else {
                self.env.logger.logDebug("Mission paused", .command, sendToConsole: true)
            }
        })
    }

    func resumeMission() {
        missionOperator?.resumeMission(completion: { (error: Error?) in
            if error != nil {
                self.env.logger.logError("Mission resume error:" + String(describing: error!.localizedDescription), .command, sendToConsole: true)
            } else {
                self.env.logger.logDebug("Mission resumed", .command, sendToConsole: true)
            }
        })
    }

    func stopMission() {
        missionOperator?.stopMission(completion: { (error: Error?) in
            if error != nil {
                self.env.logger.logError("Mission stop error:" + String(describing: error!.localizedDescription), .command, sendToConsole: true)
            } else {
                self.env.logger.logDebug("Mission stopped", .command, sendToConsole: true)
            }
        })
    }
}

// Private methods
extension CommandService {
    private func subscribe() {
        // Upload listener
        missionOperator?.addListener(toUploadEvent: self, with: DispatchQueue.main, andBlock: { (event: DJIWaypointMissionUploadEvent) in
            if event.error != nil {
                self.env.logger.logError("Upload listener error:" + String(describing: event.error!.localizedDescription), .command, sendToConsole: true)
            }
        })

        // Finished listener
        missionOperator?.addListener(toFinished: self, with: DispatchQueue.main, andBlock: { (error: Error?) in
            if error != nil {
                self.env.logger.logError("Finished listener error:" + String(describing: error!.localizedDescription), .command, sendToConsole: true)
            }
            self.env.logger.logDebug("Mission finished", .command, sendToConsole: true)
        })

        // Execution listener
        missionOperator?.addListener(toExecutionEvent: self, with: DispatchQueue.main, andBlock: { (event: DJIWaypointMissionExecutionEvent) in
            if event.error != nil {
                self.env.logger.logError("Execution listener error:" + String(describing: event.error!.localizedDescription), .command, sendToConsole: true)
            } else if let progress = event.progress {
                if self.currentWaypointIndex == nil || self.currentWaypointIndex != progress.targetWaypointIndex {
                    self.currentWaypointIndex = progress.targetWaypointIndex
                    self.env.logger.logDebug("Heading to waypoint: \(self.currentWaypointIndex!)", .command, sendToConsole: true)
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
                self.env.logger.logError("Interruption error:" + String(describing: error!.localizedDescription), .command)
                return
            }
            self.env.logger.logDebug("Mission ID \(interruption!.missionID) interrupted", .command)
        })
    }

    private func waypointMissionFromCoordinates(_ coordinates: [CLLocationCoordinate2D]) -> DJIWaypointMission {
        let mission = DJIMutableWaypointMission()
        mission.maxFlightSpeed = 15
        mission.autoFlightSpeed = 8
        mission.finishedAction = .goHome
        mission.headingMode = .auto
        mission.flightPathMode = .normal
        mission.rotateGimbalPitch = false
        mission.exitMissionOnRCSignalLost = true
        mission.gotoFirstWaypointMode = .safely
        mission.repeatTimes = 1
        for coordinate in coordinates {
            let waypoint = DJIWaypoint(coordinate: coordinate)
            waypoint.altitude = 30
            waypoint.heading = 0
            waypoint.actionRepeatTimes = 1
            waypoint.actionTimeoutInSeconds = 60
            waypoint.cornerRadiusInMeters = 5
            waypoint.turnMode = .clockwise
            waypoint.gimbalPitch = -90
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
    func modelChanged(_ model: String) {
        if model != DJIAircraftModeNameOnlyRemoteController {
            self.start()
            self.env.logger.logDebug("Starting command service", .command)
        } else {
            self.stop()
            self.env.logger.logDebug("Stopping command service", .command)
        }
    }
}
