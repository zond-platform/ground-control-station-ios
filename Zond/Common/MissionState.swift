//
//  MissionState.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 09.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

fileprivate let allowedStateTransitions: KeyValuePairs<MissionState?,MissionState?> = [
    nil             : .editing,
    .editing        : nil,
    .editing        : .uploaded,
    .uploaded       : .editing,
    .uploaded       : .running,
    .running        : .editing,
    .running        : .paused,
    .running        : nil,
    .paused         : .editing,
    .paused         : .running
]

enum MissionState {
    case uploaded
    case running
    case paused
    case editing
}

class MissionStateManager {
    // Observer properties
    var state: MissionState? {
        didSet {
            if allowedStateTransitions.contains(where: { $0 == oldValue && $1 == state }) {
                for listener in stateListeners {
                    listener?(state)
                }
            }
        }
    }

    // Notifyer properties
    var stateListeners: [((_ state: MissionState?) -> Void)?] = []
}
