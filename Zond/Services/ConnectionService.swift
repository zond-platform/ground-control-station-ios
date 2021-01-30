//
//  ConnectionService.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 12/5/18.
//  Copyright © 2018 Evgeny Agamirzov. All rights reserved.
//

import os.log

import DJISDK

class ConnectionService : BaseService {
    var listeners: [((_ model: String?) -> Void)?] = []
    var logConsole: ((_ message: String, _ type: OSLogType) -> Void)?

    override func start() {
        os_log("Starting connection service", type: .debug)
        DJISDKManager.registerApp(with: self)
        super.start()
    }

    override func stop() {
        os_log("Stopping connection service", type: .info)
        DJISDKManager.stopConnectionToProduct()
        super.stop()
    }
}

// Comply with DJI SDK manager protocol
extension ConnectionService : DJISDKManagerDelegate {
    internal func appRegisteredWithError(_ error: Error?) {
        if error != nil {
            logConsole?("SDK registration failed: \(error!.localizedDescription)", .error)
        } else {
            logConsole?("SDK Registration succeeded", .debug)
            DJISDKManager.startConnectionToProduct()
            DJISDKManager.closeConnection(whenEnteringBackground: true)
            onModelNameChanged(nil, nil)
        }
    }

    internal func productConnected(_ product: DJIBaseProduct?) {
        if product == nil {
            os_log("Connection error", type: .error)
        } else {
            os_log("Connected, starting services", type: .info)
            Environment.missionStorage.registerListeners()
            Environment.simulatorService.registerListeners()
            Environment.commandService.registerListeners()
            Environment.locationService.registerListeners()
            Environment.telemetryService.registerListeners()
            super.subscribe([
                DJIProductKey(param: DJIProductParamModelName):self.onModelNameChanged
            ])
        }
    }

    internal func productDisconnected() {
        os_log("Disconnected, stopping services", type: .info)
        super.unsubscribe()
    }

    internal func didUpdateDatabaseDownloadProgress(_: Progress) {}
}

// Aircraft key subscribtion handlers
extension ConnectionService {
    private func onModelNameChanged(_ value: DJIKeyedValue?, _: DJIKey?) {
        var model: String?
        if value == nil || value!.stringValue == nil {
            logConsole?("Product disconnected", .info)
        } else if value!.stringValue! == DJIAircraftModeNameOnlyRemoteController {
            logConsole?("Connected to \(DJIAircraftModeNameOnlyRemoteController)", .info)
        } else {
            model = value!.stringValue!
            logConsole?("Connected to \(model!)", .info)
        }
        for listener in listeners {
            listener?(model != DJIAircraftModeNameOnlyRemoteController ? model : nil)
        }
    }
}
