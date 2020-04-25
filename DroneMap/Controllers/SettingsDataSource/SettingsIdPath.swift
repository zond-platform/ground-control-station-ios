//
//  SettingsIdPath.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 25.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

struct SettingsIdPath {
    let section: SettingsSectionId
    let row: SettingsRowId

    init(_ sectionId: SettingsSectionId, _ rowId: SettingsRowId) {
        self.section = sectionId
        self.row = rowId
    }
}

func ==(lhs: SettingsIdPath, rhs: SettingsIdPath) -> Bool {
    return lhs.section == rhs.section
           && lhs.row == rhs.row
}

func ~=(pattern: SettingsIdPath, value: SettingsIdPath) -> Bool {
    return value == pattern
}
