//
//  CommandService.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 5/26/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import DJISDK

// Special service which sends commands to the aircraft
// and therefore is not required to be started/stopped
class CommandService : ServiceProtocol {
    var env: Environment
    
    init(_ env: Environment) {
        self.env = env
    }
    
    func takeOff() {
        self.env.logger.logDebug("Take off requested", .command)
        let error = DJISDKManager.missionControl()?.scheduleElement(DJITakeOffAction())
        if error != nil {
            env.logger.logError("Couldn't schedule take off element \(String(describing: error))", .command)
            return
        }
        self.env.logger.logInfo("Taking off", .command)
        DJISDKManager.missionControl()?.startTimeline()
    }
    
    func land() {
        self.env.logger.logDebug("Landing requested", .command)
        let error = DJISDKManager.missionControl()?.scheduleElement(DJILandAction())
        if error != nil {
            env.logger.logError("Couldn't schedule landing element \(String(describing: error))", .command)
            return
        }
        self.env.logger.logInfo("Landing", .command)
        DJISDKManager.missionControl()?.startTimeline()
    }
}
