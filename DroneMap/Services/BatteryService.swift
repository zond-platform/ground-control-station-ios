//
//  BatteryService.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/19/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import DJISDK

protocol BatteryServiceDelegate : AnyObject {
    func batteryChargeChanged(_ charge: UInt?)
}

class BatteryService : ServiceBase {
    var delegates: [BatteryServiceDelegate?] = []

    override init(_ env: Environment) {
        super.init(env)
        super.setKeyActionMap([
            DJIBatteryKey(param: DJIBatteryParamChargeRemainingInPercent):self.onChargeChanged
        ])
    }
}

// Public methods
extension BatteryService {
    func addDelegate(_ delegate: BatteryServiceDelegate) {
        delegates.append(delegate)
    }
}

// Private methods
extension BatteryService {
    private func onChargeChanged(_ oldValue: DJIKeyedValue?, _ newValue: DJIKeyedValue?) {
        for delegate in delegates {
            delegate?.batteryChargeChanged(newValue?.unsignedIntegerValue)
        }
    }
}
