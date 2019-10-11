//
//  SimulatorService.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 5/11/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import DJISDK

protocol SimulatorServiceDelegate : AnyObject {
    func commandResponded(_ success: Bool)
}

/*************************************************************************************************/
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

/*************************************************************************************************/
extension SimulatorService {
    private func getAircraftInstance() -> DJIAircraft? {
        guard model != DJIAircraftModeNameOnlyRemoteController else {
            env.logger.logError("Cannot run simulator on remote controller", .simulator)
            return nil
        }
        return DJISDKManager.product() as? DJIAircraft
    }
    
    func startSimulator(_ location: CLLocationCoordinate2D) {
        let aircraft = getAircraftInstance()
        if !simulatorActive && aircraft != nil {
            self.env.logger.logDebug("Attemp to start simulator", .simulator)
            aircraft!.flightController?.simulator?.start(withLocation: location,
                                                         updateFrequency: 30,
                                                         gpsSatellitesNumber: 12,
                                                         withCompletion: { (error) in
                if (error != nil) {
                    self.env.logger.logError("Start simulator error: \(error.debugDescription)", .simulator)
                    self.notifyCommandResponded(false)
                    return
                }
                self.env.logger.logInfo("Simulator started sussessfully", .simulator)
                self.notifyCommandResponded(true)
            })
        } else {
            env.logger.logError("Unable to start simulator", .simulator)
            notifyCommandResponded(false)
        }
    }
    
    func stopSimulator() {
        let aircraft = getAircraftInstance()
        if simulatorActive && aircraft != nil {
            self.env.logger.logDebug("Attemp to stop simulator", .simulator)
            aircraft!.flightController?.simulator?.stop(completion: { (error) in
                if (error != nil) {
                    self.env.logger.logError("Stop simulator error: \(error.debugDescription)", .simulator)
                    self.notifyCommandResponded(false)
                    return
                }
                self.env.logger.logInfo("Simulator stopped sussessfully", .simulator)
                self.notifyCommandResponded(true)
            })
        } else {
            env.logger.logError("Unable to stop simulator", .simulator)
            notifyCommandResponded(false)
        }
    }
}

/*************************************************************************************************/
extension SimulatorService {
    func onSimulatorStateChanged(_ oldValue: DJIKeyedValue?, _ newValue: DJIKeyedValue?) {
        guard newValue != nil else {
            return
        }
        simulatorActive = newValue!.boolValue
    }
}

/*************************************************************************************************/
extension SimulatorService : ProductServiceDelegate {
    func modelChanged(_ model: String) {
        self.model = model
    }
}

/*************************************************************************************************/
extension SimulatorService {
    func addDelegate(_ delegate: SimulatorServiceDelegate) {
        delegates.append(delegate)
    }
    
    func notifyCommandResponded(_ success: Bool) {
        for delegate in delegates {
            delegate?.commandResponded(success)
        }
    }
}
