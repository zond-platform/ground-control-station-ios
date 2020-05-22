//
//  BaseService.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/20/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import os.log

import DJISDK

class BaseService : NSObject {
    typealias KeyHandlerMap = [DJIKey?:(_ value: DJIKeyedValue?, _ key: DJIKey?) -> Void]

    private var keyHandlerMap: KeyHandlerMap = [:]
    var isActive: Bool = false

    func start() {
        isActive = true
    }

    func stop() {
        isActive = false
    }

    func subscribe(_ keyHandlerMap: KeyHandlerMap) {
        self.keyHandlerMap = keyHandlerMap
        for keyActionPair in keyHandlerMap {
            if let key = keyActionPair.key {
                DJISDKManager.keyManager()?.getValueFor(key, withCompletion: {
                    (value: DJIKeyedValue?, error: Error?) in
                    if error != nil {
                        os_log("%@", type: .error, error!.localizedDescription)
                    } else {
                        keyActionPair.value(value, key)
                    }
                })
                DJISDKManager.keyManager()?.startListeningForChanges(on: key, withListener: self, andUpdate: {
                    (_: DJIKeyedValue?, newValue: DJIKeyedValue?) in
                    keyActionPair.value(newValue, key)
                })
            } else {
                os_log("Requested DJI key does not exist", type: .error)
            }
        }
    }

    func unsubscribe() {
        for keyActionPair in keyHandlerMap {
            guard let key = keyActionPair.key else { continue }
            DJISDKManager.keyManager()?.stopListening(on: key, ofListener: self)
        }
    }
}
