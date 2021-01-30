//
//  MissionService.swift
//  Zond
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
    case goHome

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
            case .goHome:
                return "goHome"
        }
    }
}

class CommandService : BaseService {
    // Stored properties
    var currentWaypointIndex: Int?

    // Observable properties
    var activeExecutionState: DJIWaypointMissionState = .disconnected {
        didSet {
            if activeExecutionState != oldValue {
                switch activeExecutionState {
                    case .executing:
                        Environment.missionStateManager.state = .running
                    case .executionPaused:
                        Environment.missionStateManager.state = .paused
                    case .readyToExecute:
                        Environment.missionStateManager.state = .uploaded
                    default:
                        break
                }
            }
        }
    }

    // Notifyer properties
    var logConsole: ((_ message: String, _ type: OSLogType) -> Void)?
    var commandResponseListeners: [((_ id: MissionCommandId, _ success: Bool) -> Void)?] = []
    var missionFinished: ((_ success: Bool) -> Void)?
}

// Public methods
extension CommandService {
    func registerListeners() {
        Environment.connectionService.listeners.append({ model in
            if model != nil {
                super.start()
                self.subscribeToMissionEvents()
            } else {
                super.stop()
                self.unsubscribeFromMissionEvents()
            }
        })
    }

    func setMissionCoordinates(_ coordinates: [CLLocationCoordinate2D]) -> Bool {
        let missionOperator = DJISDKManager.missionControl()?.waypointMissionOperator()
        let error = missionOperator?.load(waypointMissionFromCoordinates(coordinates))
        if error != nil {
            logConsole?("Mission load error: \(error!.localizedDescription)", .error)
            return false
        } else {
            return true
        }
    }

    func executeMissionCommand(_ id: MissionCommandId) {
        if !self.isActive {
            self.logConsole?("Failed to execute \(id.title) command. Aircraft not connected.", .error)
            return
        }
        let missionOperator = DJISDKManager.missionControl()?.waypointMissionOperator()
        let callback = { [self]  (error: Error?) in
            let success = error == nil
            for listener in commandResponseListeners {
                listener?(id, success)
            }
            if success {
                let message = "Mission \(id.title) succeeded"
                logConsole?(message, .debug)
            } else {
                let message = "Mission \(id.title) error: \(error!.localizedDescription)"
                logConsole?(message, .error)
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
                if activeExecutionState != .executing && activeExecutionState != .executionPaused {
                    callback(nil)
                } else {
                    missionOperator?.stopMission(completion: callback)
                }
            case .goHome:
                missionOperator?.stopMission(completion: { [self] error in
                    if error == nil {
                        if let missionControl = DJISDKManager.missionControl() {
                            missionControl.stopTimeline()
                            missionControl.unscheduleEverything()
                            missionControl.scheduleElement(DJIGoHomeAction())
                            missionControl.startTimeline()
                            Environment.missionStateManager.state = .none
                        } else {
                            let message = "Mission control \(id.title) error: \(error!.localizedDescription)"
                            logConsole?(message, .error)
                        }
                    } else {
                        let message = "Stop before \(id.title) error: \(error!.localizedDescription)"
                        logConsole?(message, .error)
                    }
                })
        }
    }
}

// Private methods
extension CommandService {
    private func subscribeToMissionEvents() {
        let missionOperator = DJISDKManager.missionControl()?.waypointMissionOperator()
        missionOperator?.addListener(toUploadEvent: self, with: DispatchQueue.main, andBlock: { (event: DJIWaypointMissionUploadEvent) in
            if event.error != nil {
                self.logConsole?("Mission upload error: \(event.error!.localizedDescription)", .error)
            }
        })
        missionOperator?.addListener(toFinished: self, with: DispatchQueue.main, andBlock: { (error: Error?) in
            if error != nil {
                self.logConsole?("Mission finished with error: \(error!.localizedDescription)", .error)
                self.missionFinished?(false)
            } else {
                self.logConsole?("Mission finished successfully", .debug)
                self.missionFinished?(true)
            }
        })
        missionOperator?.addListener(toExecutionEvent: self, with: DispatchQueue.main, andBlock: { (event: DJIWaypointMissionExecutionEvent) in
            if event.error != nil {
                self.logConsole?("Mission execution listener error: \(event.error!.localizedDescription)", .error)
            }
            if let progress = event.progress {
                if self.currentWaypointIndex == nil || self.currentWaypointIndex != progress.targetWaypointIndex {
                    self.currentWaypointIndex = progress.targetWaypointIndex
                    if self.currentWaypointIndex != nil {
                        self.logConsole?("Heading to waypoint: \(self.currentWaypointIndex!)", .debug)
                    }
                }
            }
            self.activeExecutionState = event.currentState
        })
    }

    private func unsubscribeFromMissionEvents() {
        let missionOperator = DJISDKManager.missionControl()?.waypointMissionOperator()
        missionOperator?.removeAllListeners()
        let missionControl = DJISDKManager.missionControl()
        missionControl?.stopTimeline()
        missionControl?.unscheduleEverything()
    }

    private func waypointMissionFromCoordinates(_ coordinates: [CLLocationCoordinate2D]) -> DJIWaypointMission {
        let mission = DJIMutableWaypointMission()
        mission.maxFlightSpeed = 15
        mission.autoFlightSpeed = Environment.missionParameters.speed.value
        mission.finishedAction = .noAction
        mission.headingMode = .auto
        mission.flightPathMode = .curved
        mission.rotateGimbalPitch = true
        mission.exitMissionOnRCSignalLost = true
        mission.gotoFirstWaypointMode = .safely
        mission.repeatTimes = 1
        for coordinate in coordinates {
            let waypoint = DJIWaypoint(coordinate: coordinate)
            waypoint.altitude = Environment.missionParameters.altitude.value
            waypoint.actionRepeatTimes = 1
            waypoint.actionTimeoutInSeconds = 60
            waypoint.turnMode = .clockwise
            waypoint.gimbalPitch = -85
            waypoint.shootPhotoDistanceInterval = Environment.missionParameters.meanderStep.value
            waypoint.cornerRadiusInMeters = (Environment.missionParameters.meanderStep.value / 2) - 10e-6
            mission.add(waypoint)
        }
        return DJIWaypointMission(mission: mission)
    }
}
