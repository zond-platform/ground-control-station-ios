//
//  SettingsRowData.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 08.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum SettingsRowId {
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
                return "Enable"
            case .upload:
                return "Upload"
        }
    }
}

enum SettingsRowType {
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

class SettingsRowData<ValueType> {
    private(set) var idPath: SettingsIdPath?
    let id: SettingsRowId
    let title: String
    let type: SettingsRowType
    var value: ValueType
    var isEnabled: Bool
    var updateDisplayedData: (() -> Void)?

    init(id: SettingsRowId, type: SettingsRowType, value: ValueType, isEnabled: Bool) {
        self.id = id
        self.title = id.title
        self.type = type
        self.value = value
        self.isEnabled = isEnabled
    }
}

// Public methods
extension SettingsRowData {
    func setIdPath(_ idPath: SettingsIdPath) {
        self.idPath = idPath
    }
}
