//
//  BaseService.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/20/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import DJISDK

class BaseService {
    typealias KeyActionMap = [DJIKey?:(_ value: DJIKeyedValue?, _ key: DJIKey?) -> Void]

    var isActive: Bool = false
    var keyHandlerMap: KeyActionMap = [:]
}

// Public methods
extension BaseService {
    func subscribe(_ keyHandlerMap: KeyActionMap) {
        self.keyHandlerMap = keyHandlerMap
        for keyActionPair in keyHandlerMap {
            guard let key = keyActionPair.key else { continue }
            DJISDKManager.keyManager()?.getValueFor(key, withCompletion: {
                (value: DJIKeyedValue?, error: Error?) in
                guard error == nil else {
                    return
                }
                keyActionPair.value(value, key)
            })
            DJISDKManager.keyManager()?.startListeningForChanges(on: key, withListener: self, andUpdate: {
                (oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?) in
                keyActionPair.value(newValue, key)
            })
        }
    }

    func unsubscribe() {
        for keyActionPair in keyHandlerMap {
            guard let key = keyActionPair.key else { continue }
            DJISDKManager.keyManager()?.stopListening(on: key, ofListener: self)
        }
    }
}

// Comply with generic service protocol
extension BaseService {
    internal func start() {
        isActive = true
    }

    internal func stop() {
        isActive = false
    }
}
