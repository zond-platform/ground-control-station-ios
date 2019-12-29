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
    func signalStatusChanged(_ status: String)
    func satelliteCountChanged(_ count: UInt)
    func altitudeChanged(_ count: Double)
    func flightModeChanged(_ mode: String)
}

// Make all protocol methods optional by adding default implementations
extension LocationServiceDelegate {
    func aircraftLocationChanged(_ location: CLLocation) {}
    func aircraftHeadingChanged(_ location: CLLocationDirection) {}
    func homeLocationChanged(_ location: CLLocation) {}
    func signalStatusChanged(_ status: String) {}
    func satelliteCountChanged(_ count: UInt) {}
    func altitudeChanged(_ count: Double) {}
    func flightModeChanged(_ mode: String) {}
}

class LocationService : ServiceBase {
    var delegates: [LocationServiceDelegate?] = []
    
    override init(_ env: Environment) {
        super.init(env)
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
        notifyAircraftLocationChanged(newValue!.value! as! CLLocation)
    }

    private func onAircraftHeadingChanged(_ oldValue: DJIKeyedValue?, _ newValue: DJIKeyedValue?) {
        guard newValue != nil && newValue!.value != nil else {
            return
        }
        notifyAircraftHeadingChanged(newValue!.value! as! CLLocationDirection)
    }

    private func onHomeLocationChanged(_ oldValue: DJIKeyedValue?, _ newValue: DJIKeyedValue?) {
        guard newValue != nil && newValue!.value != nil else {
            return
        }
        notifyHomeLocationChanged(newValue!.value! as! CLLocation)
    }

    private func onGpsSignalStatusChanged(_ oldValue: DJIKeyedValue?, _ newValue: DJIKeyedValue?) {
        let gpsSignalStatusMap: [UInt8:String] = [
            0:"Almost no signal",
            1:"Very weak",
            2:"Weak",
            3:"Good",
            4:"Very good",
            5:"Very strong"
        ]
        let gpsSignalStatusString = newValue != nil
                                    ? gpsSignalStatusMap[newValue!.value as! UInt8] ?? ""
                                    : "none"
        notifySignalStatusChanged(gpsSignalStatusString)
    }

    private func onGpsSatelliteCountChanged(_ oldValue: DJIKeyedValue?, _ newValue: DJIKeyedValue?) {
        notifySatelliteCountChanged(newValue?.unsignedIntegerValue ?? 0)
    }

    private func onAltitudeChanged(_ oldValue: DJIKeyedValue?, _ newValue: DJIKeyedValue?) {
        notifyAltitudeChanged(newValue?.doubleValue ?? 0)
    }

    private func onFlightModeChanged(_ oldValue: DJIKeyedValue?, _ newValue: DJIKeyedValue?) {
        notifyFlightModeChanged(newValue?.stringValue ?? "none")
    }

    private func notifyHomeLocationChanged(_ location: CLLocation) {
        for delegate in delegates {
            delegate?.homeLocationChanged(location)
        }
    }

    private func notifyAircraftHeadingChanged(_ location: CLLocationDirection) {
        for delegate in delegates {
            delegate?.aircraftHeadingChanged(location)
        }
    }

    private func notifyAircraftLocationChanged(_ location: CLLocation) {
        for delegate in delegates {
            delegate?.aircraftLocationChanged(location)
        }
    }

    private func notifySignalStatusChanged(_ status: String) {
        for delegate in delegates {
            delegate?.signalStatusChanged(status)
        }
    }

    private func notifySatelliteCountChanged(_ count: UInt) {
        for delegate in delegates {
            delegate?.satelliteCountChanged(count)
        }
    }

    private func notifyAltitudeChanged(_ altitude: Double) {
        for delegate in delegates {
            delegate?.altitudeChanged(altitude)
        }
    }

    private func notifyFlightModeChanged(_ mode: String) {
        for delegate in delegates {
            delegate?.flightModeChanged(mode)
        }
    }
}
