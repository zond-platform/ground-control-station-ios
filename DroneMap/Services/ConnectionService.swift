//
//  ConnectionService.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 12/5/18.
//  Copyright © 2018 Evgeny Agamirzov. All rights reserved.
//

import DJISDK

enum ConnectionStatus {
    case connected
    case disconnected
    case pending
}

protocol ConnectionServiceDelegate : AnyObject {
    func statusChanged(_ status: ConnectionStatus)
}

/*************************************************************************************************/
class ConnectionService : NSObject {
    var delegates: [ConnectionServiceDelegate?] = []
    var env: Environment
    
    required init(_ env: Environment) {
        self.env = env
    }
    
    func restart() {
        stop()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.start()
        }
    }
}

/*************************************************************************************************/
extension ConnectionService : ServiceProtocol {
    func start() {
        env.logger.logDebug("Starting connection service", .connection)
        DJISDKManager.registerApp(with: self)
    }
    
    func stop() {
        env.logger.logDebug("Stopping connection service", .connection)
        DJISDKManager.stopConnectionToProduct()
    }
}

/*************************************************************************************************/
extension ConnectionService : DJISDKManagerDelegate {
    func didUpdateDatabaseDownloadProgress(_ progress: Progress) {}
    
    func appRegisteredWithError(_ error: Error?) {
        if error != nil {
            env.logger.logError("SDK registration failed: \(error!.localizedDescription)", .connection)
            return;
        }
        env.logger.logDebug("SDK Registration succeeded", .connection)
        DJISDKManager.startConnectionToProduct()
        DJISDKManager.closeConnection(whenEnteringBackground: true)
        notifyConnectionStatusChanged(.pending)
    }
    
    func productConnected(_ product: DJIBaseProduct?) {
        if product == nil {
            env.logger.logError("Connection error", .connection)
            return;
        }
        env.logger.logInfo("Connected, starting services", .connection)
        notifyConnectionStatusChanged(.connected)
    }
    
    func productDisconnected() {
        env.logger.logInfo("Disconnected, stopping services", .connection)
        self.notifyConnectionStatusChanged(.disconnected)
    }
}

/*************************************************************************************************/
extension ConnectionService {
    func addDelegate(_ delegate: ConnectionServiceDelegate) {
        delegates.append(delegate)
    }
    
    func notifyConnectionStatusChanged(_ status: ConnectionStatus) {
        for delegate in delegates {
            delegate?.statusChanged(status)
        }
    }
}
