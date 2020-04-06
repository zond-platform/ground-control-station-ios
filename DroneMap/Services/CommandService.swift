//
//  MissionService.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 5/26/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import DJISDK
import os.log

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
            os_log("Mission load error: %@", type: .error, error!.localizedDescription)
            return
        }
        missionOperator?.uploadMission(completion: { (error: Error?) in
            if error != nil {
                os_log("Mission upload error: %@", type: .error, error!.localizedDescription)
            } else {
                os_log("Mission uploaded", type: .debug)
            }
        })
    }

    func startMission() {
        missionOperator?.startMission(completion: { (error: Error?) in
            if error != nil {
                os_log("Mission start error: %@", type: .error, error!.localizedDescription)
            } else {
                os_log("Starting mission", type: .debug)
            }
        })
    }

    func pauseMission() {
        missionOperator?.pauseMission(completion: { (error: Error?) in
            if error != nil {
                os_log("Mission pause error: %@", type: .error, error!.localizedDescription)
            } else {
                os_log("Pausing mission", type: .debug)
            }
        })
    }

    func resumeMission() {
        missionOperator?.resumeMission(completion: { (error: Error?) in
            if error != nil {
                os_log("Mission resume error: %@", type: .error, error!.localizedDescription)
            } else {
                os_log("Resuming mission", type: .debug)
            }
        })
    }

    func stopMission() {
        missionOperator?.stopMission(completion: { (error: Error?) in
            if error != nil {
                os_log("Mission stop error: %@", type: .error, error!.localizedDescription)
            } else {
                os_log("Stopping mission", type: .debug)
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
    func modelChanged(_ model: String) {
        if model != DJIAircraftModeNameOnlyRemoteController {
            self.start()
        } else {
            self.stop()
        }
    }
}
