//
//  ServiceBase.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/20/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import DJISDK

class ServiceBase {
    typealias KeyActionMap = [DJIKey?:(_ value: DJIKeyedValue?, _ key: DJIKey?) -> Void]

    var keyActionMap: KeyActionMap = [:]
    var stopped: (() -> Void)?
}

// Public methods
extension ServiceBase {
    // Since actions are in fact member functions of the child class this map
    // cannot be set via the initializer and instead a setter is used.
    func setKeyActionMap(_ keyActionMap: KeyActionMap) {
        self.keyActionMap = keyActionMap
    }
}

// Comply with generic service protocol
extension ServiceBase : ServiceProtocol {
    internal func start() {
        for keyActionPair in keyActionMap {
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

    internal func stop() {
        for keyActionPair in keyActionMap {
            guard let key = keyActionPair.key else { continue }
            DJISDKManager.keyManager()?.stopListening(on: key, ofListener: self)
        }
        stopped?()
    }
}
