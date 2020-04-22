//
//  SettingsEnums.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 08.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

enum SectionId {
    case simulator
    case mission
    case status

    var headerTitle: String {
        switch self {
            case .simulator:
                return ""
            case .mission:
                return "Mission Editor"
            case .status:
                return "Aircraft Status"
        }
    }

    var footerText: String {
        switch self {
            case .simulator:
                return ""
            case .mission:
                return ""
            case .status:
                return ""
        }
    }
}

enum CellId {
    case altitude
    case battery
    case distance
    case edit
    case model
    case mode
    case satellites
    case signal
    case simulator
    case upload

    var title: String {
        switch self {
            case .altitude:
                return "Altitude"
            case .battery:
                return "Battery"
            case .distance:
                return "Grid distance"
            case .edit:
                return "Enable"
            case .mode:
                return "Flight mode"
            case .model:
                return "Model"
            case .satellites:
                return "Satellites"
            case .signal:
                return "Signal"
            case .simulator:
                return "Simulator"
            case .upload:
                return "Upload"
        }
    }
}
