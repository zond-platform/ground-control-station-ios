//
//  SettingsSectionData.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 08.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import CoreGraphics

enum SettingsSectionId {
    case simulator
    case mission
    case status

    var headerTitle: String {
        switch self {
            case .simulator:
                return "Simulator"
            case .mission:
                return "Mission Editor"
            case .status:
                return "Aircraft Status"
        }
    }

    var headerHeight: CGFloat {
        switch self {
            case .simulator:
                return AppDimensions.Settings.SimulatorSection.headerHeight
            case .mission:
                return AppDimensions.Settings.EditorSection.headerHeight
            case .status:
                return AppDimensions.Settings.StatusSection.headerHeight
        }
    }

    var footerHeight: CGFloat {
        switch self {
            case .simulator:
                return AppDimensions.Settings.SimulatorSection.footerHeight
            case .mission:
                return AppDimensions.Settings.EditorSection.footerHeight
            case .status:
                return AppDimensions.Settings.StatusSection.footerHeight
        }
    }
}

class SettingsSectionData {
    private(set) var rows: [SettingsRowData<Any>]
    let id: SettingsSectionId
    let headerTitle: String
    let headerHeight: CGFloat
    let footerHeight: CGFloat

    init(id: SettingsSectionId, rows: [SettingsRowData<Any>]) {
        self.id = id
        self.headerTitle = id.headerTitle
        self.headerHeight = id.headerHeight
        self.footerHeight = id.footerHeight
        for row in rows {
            row.setIdPath(SettingsIdPath(id, row.id))
        }
        self.rows = rows
    }
}
