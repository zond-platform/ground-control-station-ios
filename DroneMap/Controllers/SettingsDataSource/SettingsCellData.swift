//
//  SettingsCellData.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 08.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum SettingsCellId {
    case altitude
    case battery
    case flightSpeed
    case gridDistance
    case edit
    case model
    case mode
    case satellites
    case shootDistance
    case signal
    case simulator
    case upload

    var title: String {
        switch self {
            case .altitude:
                return "Altitude"
            case .battery:
                return "Battery"
            case .flightSpeed:
                return "Flight Speed"
            case .gridDistance:
                return "Grid Distance"
            case .edit:
                return "Enable"
            case .mode:
                return "Flight mode"
            case .model:
                return "Model"
            case .satellites:
                return "Satellites"
            case .shootDistance:
                return "Shoot Distance"
            case .signal:
                return "Signal"
            case .simulator:
                return "Simulator"
            case .upload:
                return "Upload"
        }
    }
}

enum SettingsCellType {
    case button
    case info
    case slider
    case switcher

    var reuseIdentifier: String {
        switch self {
            case .button:
                return "buttonCell"
            case .info:
                return "infoCell"
            case .slider:
                return "sliderCell"
            case .switcher:
                return "switcherCell"
        }
    }
}

class SettingsCellData<ValueType> {
    let id: SettingsCellId
    let title: String
    let type: SettingsCellType

    var indexPath = IndexPath()
    var value: ValueType
    var isEnabled: Bool

    init(id: SettingsCellId, type: SettingsCellType, value: ValueType, isEnabled: Bool) {
        self.id = id
        self.title = id.title
        self.type = type
        self.value = value
        self.isEnabled = isEnabled
    }
}
