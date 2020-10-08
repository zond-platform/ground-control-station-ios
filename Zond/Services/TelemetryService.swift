//
//  LocationService.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 4/27/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import DJISDK

enum TelemetryDataId {
    case flightMode
    case gpsSatellite
    case batteryCharge
    case altitude
    case velocity

    var name: String {
        switch self {
            case .flightMode:
                return "MOD"
            case .gpsSatellite:
                return "SAT"
            case .batteryCharge:
                return "BAT"
            case .altitude:
                return "A"
            case .velocity:
                return "HV"
        }
    }

    var unit: String {
        switch self {
            case .flightMode:
                return ""
            case .gpsSatellite:
                return ""
            case .batteryCharge:
                return "%"
            case .altitude:
                return "m"
            case .velocity:
                return "m/s"
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
                    DJIFlightControllerKey(param: DJIFlightControllerParamSatelliteCount):self.onValueChange,
                    DJIBatteryKey(param: DJIBatteryParamChargeRemainingInPercent):self.onValueChange,
                    DJIFlightControllerKey(param: DJIFlightControllerParamAltitudeInMeters):self.onValueChange,
                    DJIFlightControllerKey(param: DJIFlightControllerParamVelocity):self.onValueChange
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
            case DJIFlightControllerParamSatelliteCount:
                telemetryDataChanged?(.gpsSatellite, valuePresent ? String(value!.unsignedIntegerValue) : nil)
            case DJIBatteryParamChargeRemainingInPercent:
                telemetryDataChanged?(.batteryCharge, valuePresent ? String(value!.unsignedIntegerValue) : nil)
            case DJIFlightControllerParamAltitudeInMeters:
                telemetryDataChanged?(.altitude, valuePresent ? String(value!.unsignedIntegerValue) : nil)
            case DJIFlightControllerParamVelocity:
                if valuePresent {
                    let velocityVector = value!.value! as! DJISDKVector3D
                    let horizontalVelocity = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: velocityVector.x, y: velocityVector.y)).norm
                    telemetryDataChanged?(.velocity, String(format: "%.1f", Double(horizontalVelocity)))
                } else {
                    telemetryDataChanged?(.velocity, nil)
                }
            default:
                break
        }
    }
}
