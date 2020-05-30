//
//  LocationService.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/27/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import DJISDK

enum TelemetryDataId {
    case flightMode
    case gpsSignal
    case gpsSatellite
    case batteryCharge
    case altitude

    var unit: String {
        switch self {
            case .flightMode:
                return ""
            case .gpsSignal:
                return ""
            case .gpsSatellite:
                return "sat"
            case .batteryCharge:
                return "%"
            case .altitude:
                return "m"
        }
    }

    var defaultValue: String {
        switch self {
            case .flightMode:
                return "N/A"
            case .gpsSignal:
                return "N/A"
            case .gpsSatellite:
                return "0"
            case .batteryCharge:
                return "0"
            case .altitude:
                return "0"
        }
    }
}

extension TelemetryDataId : CaseIterable {}

class TelemetryService : BaseService {
    var telemetryDataChanged: ((_ id: TelemetryDataId, _ value: String?) -> Void)?
}

// Public methods
extension TelemetryService {
    func registerListeners() {
        Environment.connectionService.listeners.append({ model in
            if model != nil {
                super.start()
                super.subscribe([
                    DJIFlightControllerKey(param: DJIFlightControllerParamFlightModeString):self.onValueChange,
                    DJIFlightControllerKey(param: DJIFlightControllerParamGPSSignalStatus):self.onValueChange,
                    DJIFlightControllerKey(param: DJIFlightControllerParamSatelliteCount):self.onValueChange,
                    DJIBatteryKey(param: DJIBatteryParamChargeRemainingInPercent):self.onValueChange,
                    DJIFlightControllerKey(param: DJIFlightControllerParamAltitudeInMeters):self.onValueChange
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
        let valuePresent = value != nil && value!.value != nil
        switch key!.param {
            case DJIFlightControllerParamFlightModeString:
                telemetryDataChanged?(.flightMode, valuePresent ? value!.stringValue : nil)
            case DJIFlightControllerParamGPSSignalStatus:
                telemetryDataChanged?(.gpsSignal, valuePresent ? String(value!.unsignedIntegerValue) : nil)
            case DJIFlightControllerParamSatelliteCount:
                telemetryDataChanged?(.gpsSatellite, valuePresent ? String(value!.unsignedIntegerValue) : nil)
            case DJIBatteryParamChargeRemainingInPercent:
                telemetryDataChanged?(.batteryCharge, valuePresent ? String(value!.unsignedIntegerValue) : nil)
            case DJIFlightControllerParamAltitudeInMeters:
                telemetryDataChanged?(.altitude, valuePresent ? String(value!.unsignedIntegerValue) : nil)
            default:
                break
        }
    }
}
