//
//  MissionState.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 09.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

fileprivate let allowedStateTransitions: KeyValuePairs<MissionState,MissionState> = [
    .none     : .editing,
    .none     : .uploaded,
    .none     : .running,
    .none     : .paused,
    .editing  : .none,
    .editing  : .uploaded,
    .uploaded : .editing,
    .uploaded : .running,
    .running  : .editing,
    .running  : .paused,
    .running  : .none,
    .paused   : .editing,
    .paused   : .running
]

enum MissionState {
    case none
    case editing
    case uploaded
    case running
    case paused
}

class MissionStateManager {
    // Observer properties
    var state: MissionState = .none {
        didSet {
            if allowedStateTransitions.contains(where: { $0 == oldValue && $1 == state }) {
                for listener in stateListeners {
                    listener?(state)
                }
            }
        }
    }

    // Notifyer properties
    var stateListeners: [((_ newState: MissionState) -> Void)?] = []
}
