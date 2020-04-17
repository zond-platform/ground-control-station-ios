//
//  LocationService.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/27/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import DJISDK

protocol LocationServiceDelegate : AnyObject {
    func aircraftLocationChanged(_ location: CLLocation)
    func aircraftHeadingChanged(_ location: CLLocationDirection)
    func homeLocationChanged(_ location: CLLocation)
    func signalStatusChanged(_ status: String?)
    func satelliteCountChanged(_ count: UInt?)
    func altitudeChanged(_ count: UInt?)
    func flightModeChanged(_ mode: String?)
}

// Make all protocol methods optional by adding default implementations
extension LocationServiceDelegate {
    func aircraftLocationChanged(_ location: CLLocation) {}
    func aircraftHeadingChanged(_ location: CLLocationDirection) {}
    func homeLocationChanged(_ location: CLLocation) {}
    func signalStatusChanged(_ status: String?) {}
    func satelliteCountChanged(_ count: UInt?) {}
    func altitudeChanged(_ count: UInt?) {}
    func flightModeChanged(_ mode: String?) {}
}

class LocationService : ServiceBase {
    var delegates: [LocationServiceDelegate?] = []
    
    override init() {
        super.init()
        super.setKeyActionMap([
            DJIFlightControllerKey(param: DJIFlightControllerParamAircraftLocation):self.onAircraftLocationChanged,
            DJIFlightControllerKey(param: DJIFlightControllerParamCompassHeading):self.onAircraftHeadingChanged,
            DJIFlightControllerKey(param: DJIFlightControllerParamHomeLocation):self.onHomeLocationChanged,
            DJIFlightControllerKey(param: DJIFlightControllerParamGPSSignalStatus):self.onGpsSignalStatusChanged,
            DJIFlightControllerKey(param: DJIFlightControllerParamSatelliteCount):self.onGpsSatelliteCountChanged,
            DJIFlightControllerKey(param: DJIFlightControllerParamAltitudeInMeters):self.onAltitudeChanged,
            DJIFlightControllerKey(param: DJIFlightControllerParamFlightModeString):self.onFlightModeChanged
        ])
    }
}

// Public methods
extension LocationService {
    func addDelegate(_ delegate: LocationServiceDelegate) {
        delegates.append(delegate)
    }
}

// Private methods
extension LocationService {
    private func onAircraftLocationChanged(_ oldValue: DJIKeyedValue?, _ newValue: DJIKeyedValue?) {
        guard newValue != nil && newValue!.value != nil else {
            return
        }
        for delegate in delegates {
            delegate?.aircraftLocationChanged(newValue!.value! as! CLLocation)
        }
    }

    private func onAircraftHeadingChanged(_ oldValue: DJIKeyedValue?, _ newValue: DJIKeyedValue?) {
        guard newValue != nil && newValue!.value != nil else {
            return
        }
        for delegate in delegates {
            delegate?.aircraftHeadingChanged(newValue!.value! as! CLLocationDirection)
        }
    }

    private func onHomeLocationChanged(_ oldValue: DJIKeyedValue?, _ newValue: DJIKeyedValue?) {
        guard newValue != nil && newValue!.value != nil else {
            return
        }
        for delegate in delegates {
            delegate?.homeLocationChanged(newValue!.value! as! CLLocation)
        }
    }

    private func onGpsSignalStatusChanged(_ oldValue: DJIKeyedValue?, _ newValue: DJIKeyedValue?) {
        let gpsSignalStatusMap: [UInt:String] = [
            0:"Almost no signal",
            1:"Very weak",
            2:"Weak",
            3:"Good",
            4:"Very good",
            5:"Very strong"
        ]
        for delegate in delegates {
            delegate?.signalStatusChanged(newValue != nil
                                          ? gpsSignalStatusMap[newValue!.unsignedIntegerValue]
                                          : nil)
        }
    }

    private func onGpsSatelliteCountChanged(_ oldValue: DJIKeyedValue?, _ newValue: DJIKeyedValue?) {
        for delegate in delegates {
            delegate?.satelliteCountChanged(newValue?.unsignedIntegerValue)
        }
    }

    private func onAltitudeChanged(_ oldValue: DJIKeyedValue?, _ newValue: DJIKeyedValue?) {
        for delegate in delegates {
            delegate?.altitudeChanged(newValue?.unsignedIntegerValue)
        }
    }

    private func onFlightModeChanged(_ oldValue: DJIKeyedValue?, _ newValue: DJIKeyedValue?) {
        for delegate in delegates {
            delegate?.flightModeChanged(newValue?.stringValue)
        }
    }
}
