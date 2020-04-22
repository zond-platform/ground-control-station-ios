//
//  SettingsSectionData.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 08.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

enum SettingsSectionId {
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

class SettingsSectionData {
    let id: SettingsSectionId
    let headerTitle: String
    let footerText: String
    var entries: [SettingsCellData<Any>]

    init(id: SettingsSectionId, entries: [SettingsCellData<Any>]) {
        self.id = id
        self.headerTitle = id.headerTitle
        self.footerText = id.footerText
        self.entries = entries
    }
}
