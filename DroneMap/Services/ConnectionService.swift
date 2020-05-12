//
//  ConnectionService.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 12/5/18.
//  Copyright © 2018 Evgeny Agamirzov. All rights reserved.
//

import os.log

import DJISDK

enum ConnectionStatus {
    case connected
    case disconnected
    case pending
}

protocol ConnectionServiceDelegate : AnyObject {
    func statusChanged(_ status: ConnectionStatus)
}

class ConnectionService : NSObject {
    var delegates: [ConnectionServiceDelegate?] = []
    var logConsole: ((_ message: String, _ type: OSLogType) -> Void)?
}

// Public methods
extension ConnectionService {
    func addDelegate(_ delegate: ConnectionServiceDelegate) {
        delegates.append(delegate)
    }

    func restart() {
        stop()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.start()
        }
    }
}

// Private methods
extension ConnectionService {
    private func notifyConnectionStatusChanged(_ status: ConnectionStatus) {
        for delegate in delegates {
            delegate?.statusChanged(status)
        }
    }
}

// Comply with generic service protocol
extension ConnectionService : ServiceProtocol {
    internal func start() {
        logConsole?("Starting connection service", .debug)
        DJISDKManager.registerApp(with: self)
    }

    internal func stop() {
        logConsole?("Stopping connection service", .debug)
        DJISDKManager.stopConnectionToProduct()
    }
}

// Comply with DJI SDK manager protocol
extension ConnectionService : DJISDKManagerDelegate {
    internal func didUpdateDatabaseDownloadProgress(_ progress: Progress) {}
    
    internal func appRegisteredWithError(_ error: Error?) {
        if error != nil {
            logConsole?("SDK registration failed: \(error!.localizedDescription)", .error)
            return;
        }
        logConsole?("SDK Registration succeeded", .debug)
        DJISDKManager.startConnectionToProduct()
        DJISDKManager.closeConnection(whenEnteringBackground: true)
        notifyConnectionStatusChanged(.pending)
    }
    
    internal func productConnected(_ product: DJIBaseProduct?) {
        if product == nil {
            logConsole?("Connection error", .error)
            return;
        }
        logConsole?("Connected, starting services", .debug)
        notifyConnectionStatusChanged(.connected)
    }
    
    internal func productDisconnected() {
        logConsole?("Disconnected, stopping services", .debug)
        notifyConnectionStatusChanged(.disconnected)
    }
}
