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

class ConnectionService : NSObject {
    var connectionStatusChanged: ((_ status: ConnectionStatus) -> Void)?
    var logConsole: ((_ message: String, _ type: OSLogType) -> Void)?
}

// Comply with generic service protocol
extension ConnectionService : ServiceProtocol {
    internal func start() {
        logConsole?("Starting connection service", .info)
        let _ = Environment.productService
        let _ = Environment.simulatorService
        let _ = Environment.commandService
        let _ = Environment.telemetryService
        DJISDKManager.registerApp(with: self)
    }

    internal func stop() {
        logConsole?("Stopping connection service", .info)
        DJISDKManager.stopConnectionToProduct()
    }
}

// Comply with DJI SDK manager protocol
extension ConnectionService : DJISDKManagerDelegate {
    internal func appRegisteredWithError(_ error: Error?) {
        if error != nil {
            logConsole?("SDK registration failed: \(error!.localizedDescription)", .error)
            return;
        }
        logConsole?("SDK Registration succeeded", .info)
        DJISDKManager.startConnectionToProduct()
        DJISDKManager.closeConnection(whenEnteringBackground: true)
        connectionStatusChanged?(.pending)
    }

    internal func productConnected(_ product: DJIBaseProduct?) {
        if product == nil {
            logConsole?("Connection error", .error)
            return;
        }
        logConsole?("Connected, starting services", .info)
        connectionStatusChanged?(.connected)
    }

    internal func productDisconnected() {
        logConsole?("Disconnected, stopping services", .info)
        connectionStatusChanged?(.disconnected)
    }

    internal func didUpdateDatabaseDownloadProgress(_ progress: Progress) {}
}
