//
//  LocationService.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/27/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import DJISDK

class TelemetryService : BaseService {
    var gpsSignalStatusChanged: ((_ value: String) -> Void)?
    var gpsSatelliteCountChanged: ((_ value: String) -> Void)?
    var altitudeChanged: ((_ value: String) -> Void)?
    var flightModeChanged: ((_ value: String) -> Void)?
    var batteryChargeChanged: ((_ value: String) -> Void)?
}

// Public methods
extension TelemetryService {
    func registerListeners() {
        Environment.connectionService.listeners.append({ model in
            if model != nil {
                super.start()
                super.subscribe([
                    DJIFlightControllerKey(param: DJIFlightControllerParamGPSSignalStatus):self.onValueChange,
                    DJIFlightControllerKey(param: DJIFlightControllerParamSatelliteCount):self.onValueChange,
                    DJIFlightControllerKey(param: DJIFlightControllerParamAltitudeInMeters):self.onValueChange,
                    DJIFlightControllerKey(param: DJIFlightControllerParamFlightModeString):self.onValueChange,
                    DJIBatteryKey(param: DJIBatteryParamChargeRemainingInPercent):self.onValueChange
                ])
            } else {
                super.stop()
                super.unsubscribe()
            }
        })
    }
}

// Private methods
extension TelemetryService {
    private func onValueChange(_ value: DJIKeyedValue?, _ key: DJIKey?) {
        if value != nil && key != nil {
            switch key!.param {
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
