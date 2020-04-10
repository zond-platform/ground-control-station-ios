//
//  SimulatorService.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 5/11/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import os.log

import DJISDK

protocol SimulatorServiceDelegate : AnyObject {
    func simulatorStarted(_ success: Bool)
    func simulatorStopped(_ success: Bool)
}

class SimulatorService : ServiceBase {
    var delegates: [SimulatorServiceDelegate?] = []
    var simulatorActive: Bool = false
    var model: String?

    override init(_ env: Environment) {
        super.init(env)
        super.setKeyActionMap([
            DJIFlightControllerKey(param: DJIFlightControllerParamIsSimulatorActive):self.onSimulatorStateChanged
        ])
        env.productService().addDelegate(self)
    }
}

// Public methods
extension SimulatorService {
    func addDelegate(_ delegate: SimulatorServiceDelegate) {
        delegates.append(delegate)
    }

    func startSimulator(_ location: CLLocationCoordinate2D?) {
        let aircraft = getAircraftInstance()
        if !simulatorActive && aircraft != nil && location != nil {
            aircraft!.flightController?.simulator?.start(withLocation: location!,
                                                         updateFrequency: 30,
                                                         gpsSatellitesNumber: 12,
                                                         withCompletion: { (error) in
                if (error != nil) {
                    os_log("Start simulator error: %@", type: .error, error.debugDescription)
                    self.onSimulatorStarted(false)
                    return
                }
                os_log("Simulator started sussessfully", type: .debug)
                self.onSimulatorStarted(true)
            })
        } else {
            os_log("Unable to start simulator", type: .error)
            onSimulatorStarted(false)
        }
    }

    func stopSimulator() {
        let aircraft = getAircraftInstance()
        if simulatorActive && aircraft != nil {
            aircraft!.flightController?.simulator?.stop(completion: { (error) in
                if (error != nil) {
                    os_log("Stop simulator error: %@", type: .error, error.debugDescription)
                    self.onSimulatorStopped(false)
                    return
                }
                os_log("Simulator stopped sussessfully", type: .debug)
                self.onSimulatorStopped(true)
            })
        } else {
            os_log("Unable to stop simulator", type: .error)
            onSimulatorStopped(false)
        }
    }
}

// Private methods
extension SimulatorService {
    private func getAircraftInstance() -> DJIAircraft? {
        guard model != nil && model != DJIAircraftModeNameOnlyRemoteController else {
            os_log("Cannot run simulator on remote controller", type: .error)
            return nil
        }
        return DJISDKManager.product() as? DJIAircraft
    }

    private func onSimulatorStateChanged(_ oldValue: DJIKeyedValue?, _ newValue: DJIKeyedValue?) {
        guard newValue != nil else {
            return
        }
        simulatorActive = newValue!.boolValue
    }

    private func onSimulatorStarted(_ success: Bool) {
        for delegate in delegates {
            delegate?.simulatorStarted(success)
        }
    }

    private func onSimulatorStopped(_ success: Bool) {
        for delegate in delegates {
            delegate?.simulatorStopped(success)
        }
    }
}

// Handle vehicle model updates
extension SimulatorService : ProductServiceDelegate {
    func modelChanged(_ model: String?) {
        self.model = model
    }
}
