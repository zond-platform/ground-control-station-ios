//
//  SimulatorService.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 5/11/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import os.log

import DJISDK

class SimulatorService : BaseService {
    private var simulatorActive: Bool = false

    var logConsole: ((_ message: String, _ type: OSLogType) -> Void)?
}

// Public methods
extension SimulatorService {
    func registerListeners() {
        Environment.connectionService.listeners.append({ model in
            if model != nil {
                super.start()
                super.subscribe([
                    DJIFlightControllerKey(param: DJIFlightControllerParamIsSimulatorActive):self.onSimulatorStateChanged
                ])
            } else {
                super.stop()
                super.unsubscribe()
            }
        })
    }

    func startSimulator(_ location: CLLocationCoordinate2D?,
                        _ simulatorStarted: @escaping ((_ success: Bool) -> Void)) {
        let aircraft = DJISDKManager.product() as? DJIAircraft
        if !simulatorActive && aircraft != nil && location != nil {
            aircraft!.flightController?.simulator?.start(withLocation: location!,
                                                         updateFrequency: 30,
                                                         gpsSatellitesNumber: 12,
                                                         withCompletion: { (error) in
                if (error != nil) {
                    self.logConsole?("Start simulator error: \(error.debugDescription)", .error)
                    simulatorStarted(false)
                } else {
                    self.logConsole?("Simulator started sussessfully", .debug)
                    simulatorStarted(true)
                }
            })
        } else {
            logConsole?("Cannot start simulator. Aircraft not connected.", .error)
            simulatorStarted(false)
        }
    }

    func stopSimulator(_ simulatorStopped: @escaping ((_ success: Bool) -> Void)) {
        let aircraft = DJISDKManager.product() as? DJIAircraft
        if simulatorActive && aircraft != nil {
            aircraft!.flightController?.simulator?.stop(completion: { (error) in
                if (error != nil) {
                    self.logConsole?("Stop simulator error: \(error.debugDescription)", .error)
                    simulatorStopped(false)
                } else {
                    self.logConsole?("Simulator stopped sussessfully", .debug)
                    simulatorStopped(true)
                }
            })
        } else {
            logConsole?("Cannot start simulator. Aircraft not connected.", .error)
            simulatorStopped(false)
        }
    }
}

// Private methods
extension SimulatorService {
    private func onSimulatorStateChanged(_ value: DJIKeyedValue?, _: DJIKey?) {
        if value == nil {
            simulatorActive = false
        } else {
            simulatorActive = value!.boolValue
        }
    }
}
