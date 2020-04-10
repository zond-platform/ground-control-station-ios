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

    var title: String {
        switch self {
            case .simulator:
                return ""
            case .mission:
                return "Mission"
            case .status:
                return "Status"
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
                return "Enable editing"
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

enum CellType {
    case button
    case info
    case slider
    case switcher

    var reuseIdentifier: String {
        switch self {
            case .button:
                return "segueCell"
            case .info:
                return "infoCell"
            case .slider:
                return "tuneCell"
            case .switcher:
                return "switchCell"
        }
    }
}

