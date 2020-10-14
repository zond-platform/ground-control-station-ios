//
//  LocationService.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 4/27/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import DJISDK

class TelemetryService : BaseService {
    // Static telemetry notifyers
    var flightModeChanged: ((_ value: String?) -> Void)?
    var gpsSignalStatusChanged: ((_ value: UInt?) -> Void)?
    var gpsSatCountChanged: ((_ value: UInt?) -> Void)?
    var linkSignalQualityChanged: ((_ value: UInt?) -> Void)?
    var batteryChargeChanged: ((_ value: UInt?) -> Void)?

    // Dynamic telemetry notifiers
    var altitudeChanged: ((_ value: UInt?) -> Void)?
    var horizontalVelocityChanged: ((_ value: Double?) -> Void)?
    var verticalVelocityChanged: ((_ value: Double?) -> Void)?
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
                    DJIAirLinkKey(param: DJIAirLinkParamUplinkSignalQuality):self.onValueChange,
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
                flightModeChanged?(valuePresent ? value!.stringValue : nil)
            case DJIFlightControllerParamGPSSignalStatus:
                    gpsSignalStatusChanged?(valuePresent ? value!.unsignedIntegerValue : nil)
            case DJIFlightControllerParamSatelliteCount:
                gpsSatCountChanged?(valuePresent ? value!.unsignedIntegerValue : nil)
            case DJIAirLinkParamUplinkSignalQuality:
                linkSignalQualityChanged?(valuePresent ? value!.unsignedIntegerValue : nil)
            case DJIBatteryParamChargeRemainingInPercent:
                batteryChargeChanged?(valuePresent ? value!.unsignedIntegerValue : nil)
            case DJIFlightControllerParamAltitudeInMeters:
                altitudeChanged?(valuePresent ? value!.unsignedIntegerValue : nil)
            case DJIFlightControllerParamVelocity:
                if valuePresent {
                    let velocityVector = value!.value! as! DJISDKVector3D
                    let horizontalVelocity = Vector(CGPoint(x: 0.0, y: 0.0), CGPoint(x: velocityVector.x, y: velocityVector.y)).norm
                    horizontalVelocityChanged?(Double(horizontalVelocity))
                    verticalVelocityChanged?(Double(velocityVector.z))
                } else {
                    horizontalVelocityChanged?(nil)
                    verticalVelocityChanged?(nil)
                }
            default:
                break
        }
    }
}
