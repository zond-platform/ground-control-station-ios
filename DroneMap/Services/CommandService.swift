//
//  MissionService.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 5/26/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import os.log

import DJISDK

enum MissionCommandId {
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

struct MissionParameters {
    var flightSpeed: Float = 10.0 {
        didSet {
            if flightSpeed <= Float(1.0) && flightSpeed >= Float(15.0) {
                flightSpeed = Float(10.0)
            }
        }
    }

    var shootDistance: Float = 10.0 {
        didSet {
            if shootDistance <= Float(10.0) && shootDistance >= Float(50.0) {
                shootDistance = Float(10.0)
            }
        }
    }

    var altitude: Float = 20.0 {
        didSet {
            if altitude <= Float(20.0) && altitude >= Float(200.0) {
                altitude = Float(10.0)
            }
        }
    }
}

class CommandService : NSObject {
    var currentWaypointIndex: Int?
    var missionOperator: DJIWaypointMissionOperator?
    var missionParameters = MissionParameters()
    var logConsole: ((_ message: String, _ type: OSLogType) -> Void)?
    var commandResponded: ((_ id: MissionCommandId, _ success: Bool) -> Void)?
    
    override init() {
        super.init()
        Environment.productService.addDelegate(self)
    }
}

// Public methods
extension CommandService {
    func setMissionCoordinates(_ coordinates: [CLLocationCoordinate2D]) -> Bool {
        let error = missionOperator?.load(waypointMissionFromCoordinates(coordinates))
        guard error == nil else {
            logConsole?("Mission load error: \(error!.localizedDescription)", .error)
            return false
        }
        return true
    }

    func executeMissionCommand(_ id: MissionCommandId) {
        let callback = { (error: Error?) in
            let success = error == nil
            self.commandResponded?(id, success)
            if success {
                let message = "Mission \(id.title) succeeded"
                let type = OSLogType.debug
                self.logConsole?(message, type)
            } else {
                let message = "Mission \(id.title) error: \(error!.localizedDescription)"
                let type = OSLogType.error
                self.logConsole?(message, type)
            }
        }
        switch id {
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
        missionOperator?.addListener(toUploadEvent: self, with: DispatchQueue.main, andBlock: { (event: DJIWaypointMissionUploadEvent) in
            if event.error != nil {
                self.logConsole?("Upload listener error: \(event.error!.localizedDescription)", .error)
            }
        })
        missionOperator?.addListener(toFinished: self, with: DispatchQueue.main, andBlock: { (error: Error?) in
            if error != nil {
                self.logConsole?("Finished listener error: \(error!.localizedDescription)", .error)
            } else {
                self.logConsole?("Mission finished", .debug)
            }
        })
        missionOperator?.addListener(toExecutionEvent: self, with: DispatchQueue.main, andBlock: { (event: DJIWaypointMissionExecutionEvent) in
            if event.error != nil {
                self.logConsole?("Execution listener error: \(event.error!.localizedDescription)", .error)
            } else if let progress = event.progress {
                if self.currentWaypointIndex == nil || self.currentWaypointIndex != progress.targetWaypointIndex {
                    self.currentWaypointIndex = progress.targetWaypointIndex
                    if self.currentWaypointIndex != nil {
                        self.logConsole?("Heading to waypoint: \(self.currentWaypointIndex!)", .debug)
                    }
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
                self.logConsole?("Interruption error: \(error!.localizedDescription)", .error)
                return
            }
            self.logConsole?("Mission ID \(interruption!.missionID) interrupted", .debug)
        })
    }

    private func waypointMissionFromCoordinates(_ coordinates: [CLLocationCoordinate2D]) -> DJIWaypointMission {
        let mission = DJIMutableWaypointMission()
        mission.maxFlightSpeed = 15
        mission.autoFlightSpeed = missionParameters.flightSpeed
        mission.finishedAction = .goHome
        mission.headingMode = .auto
        mission.flightPathMode = .curved
        mission.rotateGimbalPitch = true
        mission.exitMissionOnRCSignalLost = true
        mission.gotoFirstWaypointMode = .safely
        mission.repeatTimes = 1
        for coordinate in coordinates {
            let waypoint = DJIWaypoint(coordinate: coordinate)
            waypoint.altitude = missionParameters.altitude
            waypoint.actionRepeatTimes = 1
            waypoint.actionTimeoutInSeconds = 60
            waypoint.turnMode = .clockwise
            waypoint.gimbalPitch = -90
            waypoint.shootPhotoDistanceInterval = missionParameters.shootDistance
            waypoint.cornerRadiusInMeters = 4
            mission.add(waypoint)
        }
        return DJIWaypointMission(mission: mission)
    }
}

// Comply with generic service protocol
extension CommandService : ServiceProtocol {
    internal func start() {
        missionOperator = DJISDKManager.missionControl()?.waypointMissionOperator()
        subscribe()
    }

    internal func stop() {
        missionOperator = nil
        unsubscribe()
    }
}

// Subscribe to connected product updates
extension CommandService : ProductServiceDelegate {
    internal func modelChanged(_ model: String?) {
        if model != nil && model != DJIAircraftModeNameOnlyRemoteController {
            self.start()
        } else {
            self.stop()
        }
    }
}
