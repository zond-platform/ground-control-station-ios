//
//  ProductService.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/19/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import DJISDK

class ProductService : ServiceBase {
    var aircraftPresenceNotifiers: [((_ model: String?) -> Void)?] = []

    override init() {
        super.init()
        super.setKeyActionMap([
            DJIProductKey(param: DJIProductParamModelName):self.onModelNameChanged
        ])
        registerCallbacks()
    }
}

// Private methods
extension ProductService {
    private func registerCallbacks() {
        Environment.connectionService.connectionStatusChanged = { status in
            if status == .connected {
                super.start()
            } else {
                super.stop()
            }
        }
    }

    private func onModelNameChanged(_ value: DJIKeyedValue?, _: DJIKey?) {
        let model = value?.stringValue
        for notifyer in aircraftPresenceNotifiers {
            notifyer?((model != nil && model != DJIAircraftModeNameOnlyRemoteController) ? model : nil)
        }
    }
}
