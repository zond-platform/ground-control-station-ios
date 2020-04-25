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
    let flightSpeed: Float?
    let shootDistance: Float?
    let altitude: Float?

    func valid() -> Bool {
        return flightSpeed != nil && shootDistance != nil && altitude != nil
    }
}

protocol CommandServiceDelegate : AnyObject {
    func missionCommandResponded(_ commandId: MissionCommandId, _ success: Bool)
    func setingMissionParametersFailed()
    func setingMissionCoordinatesFailed()
}

extension CommandServiceDelegate {
    func missionCommandResponded(_ commandId: MissionCommandId, _ success: Bool) {}
    func setingMissionParametersFailed() {}
    func setingMissionCoordinatesFailed() {}
}

class CommandService : NSObject {
    var currentWaypointIndex: Int?
    var missionOperator: DJIWaypointMissionOperator?
    var delegates: [CommandServiceDelegate?] = []
    var missionParameters: MissionParameters
    
    override init() {
        missionParameters = MissionParameters(flightSpeed: 10, shootDistance: 20, altitude: 30)
        super.init()
        Environment.productService.addDelegate(self)
    }
}

// Public methods
extension CommandService {
    func addDelegate(_ delegate: CommandServiceDelegate) {
        delegates.append(delegate)
    }

    func setMissionParameters(_ parameters: MissionParameters) -> Bool {
        if !missionParameters.valid() {
            os_log("Mission parameters are invalid", type: .error)
            for delegate in self.delegates {
                delegate?.setingMissionParametersFailed()
            }
            return false
        }
        missionParameters = parameters
        return true
    }

    func setMissionCoordinates(_ coordinates: [CLLocationCoordinate2D]) -> Bool {
        let error = missionOperator?.load(waypointMissionFromCoordinates(coordinates))
        guard error == nil else {
            os_log("Mission load error: %@", type: .error, error!.localizedDescription)
            for delegate in self.delegates {
                delegate?.setingMissionCoordinatesFailed()
            }
            return false
        }
        return true
    }

    func executeMissionCommand(_ commandId: MissionCommandId) {
        let callback = { (error: Error?) in
            let success = error == nil
            if success {
                os_log("Mission %@ succeeded", type: .debug, commandId.title)
            } else {
                os_log("Mission %@ error: %@", type: .error, commandId.title, error!.localizedDescription)
            }
            for delegate in self.delegates {
                delegate?.missionCommandResponded(commandId, success)
            }
        }
        switch commandId {
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
                os_log("Upload listener error: %@", type: .error, event.error!.localizedDescription)
            }
        })
        missionOperator?.addListener(toFinished: self, with: DispatchQueue.main, andBlock: { (error: Error?) in
            if error != nil {
                os_log("Finished listener error: %@", type: .error, error!.localizedDescription)
                return
            }
            os_log("Mission finished", type: .debug)
        })
        missionOperator?.addListener(toExecutionEvent: self, with: DispatchQueue.main, andBlock: { (event: DJIWaypointMissionExecutionEvent) in
            if event.error != nil {
                os_log("Execution listener error: %@", type: .error, event.error!.localizedDescription)
            } else if let progress = event.progress {
                if self.currentWaypointIndex == nil || self.currentWaypointIndex != progress.targetWaypointIndex {
                    self.currentWaypointIndex = progress.targetWaypointIndex
                    os_log("%@", type: .debug, String(describing: self.currentWaypointIndex))
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
        mission.autoFlightSpeed = missionParameters.flightSpeed!
        mission.finishedAction = .goHome
        mission.headingMode = .auto
        mission.flightPathMode = .curved
        mission.rotateGimbalPitch = true
        mission.exitMissionOnRCSignalLost = true
        mission.gotoFirstWaypointMode = .safely
        mission.repeatTimes = 1
        for coordinate in coordinates {
            let waypoint = DJIWaypoint(coordinate: coordinate)
            waypoint.altitude = missionParameters.altitude!
            waypoint.actionRepeatTimes = 1
            waypoint.actionTimeoutInSeconds = 60
            waypoint.turnMode = .clockwise
            waypoint.gimbalPitch = -90
            waypoint.shootPhotoDistanceInterval = missionParameters.shootDistance!
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
