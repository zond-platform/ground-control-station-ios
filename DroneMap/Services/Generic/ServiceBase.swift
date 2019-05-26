//
//  ServiceBase.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/20/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import DJISDK

/*

New parameters to consider:

DJIFlightControllerKey
- DJIFlightControllerParamIMUState
- DJIFlightControllerParamFlightMode
- DJIFlightControllerParamAltitudeInMeters
- DJIFlightControllerParamFlightTimeInSeconds
- DJIFlightControllerParamCompassHeading
- DJIFlightControllerParamCompassState
- DJIFlightControllerParamCompassHasError
- DJIFlightControllerParamIMUState
- DJIFlightControllerParamIMUAccelerometerState

*/

class ServiceBase {
    typealias Action = (_ oldValue: DJIKeyedValue?, _ newValue: DJIKeyedValue?) -> Void
    typealias ParamActionMap = [String:Action]
    typealias KeyActionMap = [DJIKey:Action]

    var env: Environment
    var keyActionMap: KeyActionMap = [:]
    
    required init(_ env: Environment) {
        self.env = env
        env.connectionService().addDelegate(self)
    }

    func addKey(_ key: DJIKey?, _ action: @escaping Action) {
        guard key != nil else {
            return
        }
        keyActionMap[key!] = action
    }
}

extension ServiceBase : ServiceProtocol {
    func start() {
        for keyActionPair in keyActionMap {
            DJISDKManager.keyManager()?.getValueFor(keyActionPair.key, withCompletion: {
                (value: DJIKeyedValue?, error: Error?) in
                guard error == nil else {
                    return
                }
                keyActionPair.value(nil, value)
            })
            DJISDKManager.keyManager()?.startListeningForChanges(on: keyActionPair.key, withListener: self, andUpdate: {
                (oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?) in
                keyActionPair.value(oldValue, newValue)
            })
        }
    }
    
    func stop() {
        for keyActionPair in keyActionMap {
            DJISDKManager.keyManager()?.stopListening(on: keyActionPair.key, ofListener: self)
        }
    }
}

extension ServiceBase : ConnectionServiceDelegate {
    func statusChanged(_ status: ConnectionStatus) {
        if status == .connected {
            self.start()
        } else {
            self.stop()
        }
    }
}
