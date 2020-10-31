//
//  LocationService.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 20.05.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import DJISDK

class LocationService : BaseService {
    var aircraftLocationListeners: [((_ value: CLLocation?) -> Void)?] = []
    var homeLocationListeners: [((_ value: CLLocation?) -> Void)?] = []
    var aircraftHeadingChanged: ((_ value: CLLocationDirection?) -> Void)?
}

// Public methods
extension LocationService {
    func registerListeners() {
        Environment.connectionService.listeners.append({ model in
            if model != nil {
                super.start()
                super.subscribe([
                    DJIFlightControllerKey(param: DJIFlightControllerParamAircraftLocation):self.onValueChange,
                    DJIFlightControllerKey(param: DJIFlightControllerParamHomeLocation):self.onValueChange,
                    DJIFlightControllerKey(param: DJIFlightControllerParamCompassHeading):self.onValueChange,
                ])
            } else {
                super.stop()
                super.unsubscribe()
            }
        })
    }
}

// Private methods
extension LocationService {
    private func onValueChange(_ value: DJIKeyedValue?, _ key: DJIKey?) {
        let valuePresent = value != nil && value!.value != nil
        switch key!.param {
            case DJIFlightControllerParamAircraftLocation:
                for listener in aircraftLocationListeners {
                    listener?(valuePresent ? (value!.value! as? CLLocation) : nil)
                }
            case DJIFlightControllerParamHomeLocation:
                for listener in homeLocationListeners {
                    listener?(valuePresent ? (value!.value! as? CLLocation) : nil)
                }
            case DJIFlightControllerParamCompassHeading:
                aircraftHeadingChanged?(valuePresent ? (value!.value! as? CLLocationDirection) : nil)
            default:
                break
        }
    }
}
