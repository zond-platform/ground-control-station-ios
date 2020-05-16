//
//  SimulatorService.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 5/11/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import os.log

import DJISDK

class SimulatorService : ServiceBase {
    private var simulatorActive: Bool = false
    var logConsole: ((_ message: String, _ type: OSLogType) -> Void)?

    override init() {
        super.init()
        super.setKeyActionMap([
            DJIFlightControllerKey(param: DJIFlightControllerParamIsSimulatorActive):self.onSimulatorStateChanged
        ])
        registerCallbacks()
    }
}

// Public methods
extension SimulatorService {
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
                    return
                }
                self.logConsole?("Simulator started sussessfully", .debug)
                simulatorStarted(true)
            })
        } else {
            logConsole?("Unable to start simulator", .error)
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
                    return
                }
                self.logConsole?("Simulator stopped sussessfully", .debug)
                simulatorStopped(true)
            })
        } else {
            logConsole?("Unable to stop simulator", .error)
            simulatorStopped(false)
        }
    }
}

// Private methods
extension SimulatorService {
    private func registerCallbacks() {
        Environment.productService.aircraftPresenceNotifiers.append({ model in
            if model != nil {
                super.start()
            } else {
                super.stop()
            }
        })
    }

    private func onSimulatorStateChanged(_ value: DJIKeyedValue?, _: DJIKey?) {
        guard value != nil else {
            return
        }
        simulatorActive = value!.boolValue
        if !simulatorActive {
            stopped?()
        }
    }
}
