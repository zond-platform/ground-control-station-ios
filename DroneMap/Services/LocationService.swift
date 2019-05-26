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
    func homeLocationChanged(_ location: CLLocation)
    func signalStatusChanged(_ status: String)
    func satelliteCountChanged(_ count: UInt)
    func altitudeChanged(_ count: Double)
    func flightModeChanged(_ mode: String)
}

// Make all protocol methods optional by adding default implementations
extension LocationServiceDelegate {
    func aircraftLocationChanged(_ location: CLLocation) {}
    func homeLocationChanged(_ location: CLLocation) {}
    func signalStatusChanged(_ status: String) {}
    func satelliteCountChanged(_ count: UInt) {}
    func altitudeChanged(_ count: Double) {}
    func flightModeChanged(_ mode: String) {}
}

/*************************************************************************************************/
class LocationService : ServiceBase {
    var delegates: [LocationServiceDelegate?] = []
    
    override init(_ env: Environment) {
        super.init(env)
        super.setKeyActionMap([
            DJIFlightControllerKey(param: DJIFlightControllerParamAircraftLocation):self.onAircraftLocationChanged,
            DJIFlightControllerKey(param: DJIFlightControllerParamHomeLocation):self.onHomeLocationChanged,
            DJIFlightControllerKey(param: DJIFlightControllerParamGPSSignalStatus):self.onGpsSignalStatusChanged,
            DJIFlightControllerKey(param: DJIFlightControllerParamSatelliteCount):self.onGpsSatelliteCountChanged,
            DJIFlightControllerKey(param: DJIFlightControllerParamAltitudeInMeters):self.onAltitudeChanged,
            DJIFlightControllerKey(param: DJIFlightControllerParamFlightModeString):self.onFlightModeChanged
        ])
    }
}

/*************************************************************************************************/
extension LocationService {
    func onAircraftLocationChanged(_ oldValue: DJIKeyedValue?, _ newValue: DJIKeyedValue?) {
        guard newValue != nil && newValue!.value != nil else {
            return
        }
        let aircraftLocation = newValue!.value! as! CLLocation
        notifyAircraftLocationChanged(aircraftLocation)
    }
    
    func onHomeLocationChanged(_ oldValue: DJIKeyedValue?, _ newValue: DJIKeyedValue?) {
        guard newValue != nil && newValue!.value != nil else {
            return
        }
        let homeLocation = newValue!.value! as! CLLocation
        notifyHomeLocationChanged(homeLocation)
    }
    
    func onGpsSignalStatusChanged(_ oldValue: DJIKeyedValue?, _ newValue: DJIKeyedValue?) {
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

    func onGpsSatelliteCountChanged(_ oldValue: DJIKeyedValue?, _ newValue: DJIKeyedValue?) {
        notifySatelliteCountChanged(newValue?.unsignedIntegerValue ?? 0)
    }
    
    func onAltitudeChanged(_ oldValue: DJIKeyedValue?, _ newValue: DJIKeyedValue?) {
        notifyAltitudeChanged(newValue?.doubleValue ?? 0)
    }
    
    func onFlightModeChanged(_ oldValue: DJIKeyedValue?, _ newValue: DJIKeyedValue?) {
        notifyFlightModeChanged(newValue?.stringValue ?? "none")
    }
}

/*************************************************************************************************/
extension LocationService {
    func addDelegate(_ delegate: LocationServiceDelegate) {
        delegates.append(delegate)
    }
    
    func notifyHomeLocationChanged(_ location: CLLocation) {
        for delegate in delegates {
            delegate?.homeLocationChanged(location)
        }
    }
    
    func notifyAircraftLocationChanged(_ location: CLLocation) {
        for delegate in delegates {
            delegate?.aircraftLocationChanged(location)
        }
    }
    
    func notifySignalStatusChanged(_ status: String) {
        for delegate in delegates {
            delegate?.signalStatusChanged(status)
        }
    }
    
    func notifySatelliteCountChanged(_ count: UInt) {
        for delegate in delegates {
            delegate?.satelliteCountChanged(count)
        }
    }
    
    func notifyAltitudeChanged(_ altitude: Double) {
        for delegate in delegates {
            delegate?.altitudeChanged(altitude)
        }
    }
    
    func notifyFlightModeChanged(_ mode: String) {
        for delegate in delegates {
            delegate?.flightModeChanged(mode)
        }
    }
}
