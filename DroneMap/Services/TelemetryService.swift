//
//  LocationService.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/27/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import DJISDK

class TelemetryService : ServiceBase {
    var aircraftLocationChanged: ((_ value: CLLocation) -> Void)?
    var homeLocationChanged: ((_ value: CLLocation) -> Void)?
    var aircraftHeadingChanged: ((_ value: CLLocationDirection) -> Void)?
    var gpsSignalStatusChanged: ((_ value: String) -> Void)?
    var gpsSatelliteCountChanged: ((_ value: String) -> Void)?
    var altitudeChanged: ((_ value: String) -> Void)?
    var flightModeChanged: ((_ value: String) -> Void)?
    var batteryChargeChanged: ((_ value: String) -> Void)?

    override init() {
        super.init()
        super.setKeyActionMap([
            DJIFlightControllerKey(param: DJIFlightControllerParamAircraftLocation):self.onValueChange,
            DJIFlightControllerKey(param: DJIFlightControllerParamHomeLocation):self.onValueChange,
            DJIFlightControllerKey(param: DJIFlightControllerParamCompassHeading):self.onValueChange,
            DJIFlightControllerKey(param: DJIFlightControllerParamGPSSignalStatus):self.onValueChange,
            DJIFlightControllerKey(param: DJIFlightControllerParamSatelliteCount):self.onValueChange,
            DJIFlightControllerKey(param: DJIFlightControllerParamAltitudeInMeters):self.onValueChange,
            DJIFlightControllerKey(param: DJIFlightControllerParamFlightModeString):self.onValueChange,
            DJIBatteryKey(param: DJIBatteryParamChargeRemainingInPercent):self.onValueChange
        ])
        registerCallbacks()
    }
}

// Private methods
extension TelemetryService {
    private func registerCallbacks() {
        Environment.productService.aircraftPresenceNotifiers.append({ model in
            if model != nil {
                super.start()
            } else {
                super.stop()
            }
        })
    }

    private func onValueChange(_ value: DJIKeyedValue?, _ key: DJIKey?) {
        if value != nil && key != nil {
            switch key!.param {
                case DJIFlightControllerParamAircraftLocation:
                    if value!.value != nil {
                        aircraftLocationChanged?(value!.value! as! CLLocation)
                    }
                case DJIFlightControllerParamHomeLocation:
                    if value!.value != nil {
                        homeLocationChanged?(value!.value! as! CLLocation)
                    }
                case DJIFlightControllerParamCompassHeading:
                    if value!.value != nil {
                        aircraftHeadingChanged?(value!.value! as! CLLocationDirection)
                    }
                case DJIFlightControllerParamGPSSignalStatus:
                    let gpsSignalStatusMap: [UInt:String] = [
                        0:"Almost no signal",
                        1:"Very weak",
                        2:"Weak",
                        3:"Good",
                        4:"Very good",
                        5:"Very strong"
                    ]
                    gpsSignalStatusChanged?(gpsSignalStatusMap[value!.unsignedIntegerValue] ?? "-")
                case DJIFlightControllerParamSatelliteCount:
                    gpsSatelliteCountChanged?(String(value!.unsignedIntegerValue))
                case DJIFlightControllerParamAltitudeInMeters:
                    altitudeChanged?(String(value!.unsignedIntegerValue))
                case DJIFlightControllerParamFlightModeString:
                    flightModeChanged?(String(value!.stringValue ?? "-"))
                case DJIBatteryParamChargeRemainingInPercent:
                    batteryChargeChanged?(String(value!.unsignedIntegerValue))
                default:
                    break
            }
        }
    }
}
