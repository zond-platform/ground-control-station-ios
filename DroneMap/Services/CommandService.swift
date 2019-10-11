//
//  CommandService.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 5/26/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import DJISDK

enum Command {
    case takeoff
    case land
    case mission
}

class CommandService : NSObject {
    var env: Environment
    var connected = false
    
    init(_ env: Environment) {
        self.env = env
        super.init()
        env.connectionService().addDelegate(self)
    }
    
    func commandActionMap(_ command: Command) -> DJIMissionAction? {
        switch command {
        case .takeoff:
            return DJITakeOffAction()
        case .land:
            return DJILandAction()
        default:
            return nil
        }
    }
    
    func doAction(_ command: Command) {
        self.env.logger.logDebug("Requesting command: \(String(describing: command))", .command)
        if !connected {
            env.logger.logError("No aircraft connected", .command)
            return
        }
        let action = commandActionMap(command)
        if action == nil {
            env.logger.logError("Unknown action requested", .command)
            return
        }
        let error = DJISDKManager.missionControl()?.scheduleElement(action!)
        if error != nil {
            env.logger.logError(String(describing: error!.localizedDescription), .command)
            return
        }
        DJISDKManager.missionControl()?.startTimeline()
    }
}

/*************************************************************************************************/
extension CommandService : ServiceProtocol {
    func start() {
        // Subscribe
        connected = true
        DJISDKManager.missionControl()?.addListener(self, toTimelineProgressWith:
            { (_ event: DJIMissionControlTimelineEvent, _ element: DJIMissionControlTimelineElement?, _ error: Error?, _ info: Any) in
                if error != nil {
                    self.env.logger.logError(String(describing: error!.localizedDescription), .command)
                    return
                }
                let timelineEventMap: [Int:String] = [
                    -1:"Unknown event type",
                    0: "Timeline successfully started",
                    1: "Timeline failed to start",
                    2: "Timeline element progressed",
                    3: "Timeline successfully paused",
                    4: "Timeline failed to be paused",
                    5: "Timeline successfully resumed",
                    6: "Timeline failed to resume",
                    7: "Timeline Stopped successfully",
                    8: "Timeline failed to stop and is still continuing in its previous state",
                    9: "Timeline completed its execution normally"
                ]
                self.env.logger.logInfo(String(describing: timelineEventMap[event.rawValue]!), .command)
            })
    }
    
    func stop() {
        // Unsubscribe
        connected = false
        DJISDKManager.missionControl()?.stopTimeline()
    }
}

extension CommandService : DJIMissionControlTimelineElementFeedback {
    func elementDidStartRunning(_ element: DJIMissionControlTimelineElement) {
        
    }
    
    func element(_ element: DJIMissionControlTimelineElement, failedStartingWithError error: Error) {
        
    }
    
    func element(_ element: DJIMissionControlTimelineElement, progressedWithError error: Error?) {
        
    }
    
    func elementDidPause(_ element: DJIMissionControlTimelineElement) {
        
    }
    
    func element(_ element: DJIMissionControlTimelineElement, failedPausingWithError error: Error) {
        
    }
    
    func elementDidResume(_ element: DJIMissionControlTimelineElement) {
        
    }
    
    func element(_ element: DJIMissionControlTimelineElement, failedResumingWithError error: Error) {
        
    }
    
    func element(_ element: DJIMissionControlTimelineElement, didFinishRunningWithError error: Error?) {
        
    }
    
    func elementDidStopRunning(_ element: DJIMissionControlTimelineElement) {
        self.env.logger.logInfo("Delegate alive?", .command)
        DJISDKManager.missionControl()?.stopTimeline()
    }
    
    func element(_ element: DJIMissionControlTimelineElement, failedStoppingWithError error: Error) {
        
    }
}

// Replace with ProductServiceDelegate
/*************************************************************************************************/
extension CommandService : ConnectionServiceDelegate {
    func statusChanged(_ status: ConnectionStatus) {
        if status == .connected {
            self.start()
        } else {
            self.stop()
        }
    }
}
