//
//  SettingsData.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 20.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

struct IdPath {
    let section: SettingsSectionId
    let cell: SettingsCellId

    init(_ sectionId: SettingsSectionId, _ cellId: SettingsCellId) {
        self.section = sectionId
        self.cell = cellId
    }
}

class SettingsTableData {
    private var entries: [SettingsSectionData]
    
    init(_ entries: [SettingsSectionData]) {
        self.entries = entries
    }
}

// Access
extension SettingsTableData {
    func sectionsCount() -> Int {
        return entries.count
    }

    func cellsCount(in section: Int) -> Int {
        return entries[section].entries.count
    }

    func title(forHeaderIn section: Int) -> String {
        return entries[section].headerTitle
    }

    func text(forFooterIn section: Int) -> String {
        return entries[section].footerText
    }

    func entry(at indexPath: IndexPath) -> SettingsCellData<Any> {
        return entries[indexPath.section].entries[indexPath.row]
    }
}

// Modification
extension SettingsTableData {
    func updateEntry<ValueType>(at indexPath: IndexPath, with value: ValueType) -> SettingsCellData<Any> {
        entries[indexPath.section].entries[indexPath.row].value = value
        return entries[indexPath.section].entries[indexPath.row]
    }

    func enableEntry(at indexPath: IndexPath, _ shouldEnable: Bool) -> SettingsCellData<Any> {
        entries[indexPath.section].entries[indexPath.row].isEnabled = shouldEnable
        return entries[indexPath.section].entries[indexPath.row]
    }

    func storeIndexPath(inEntryAt indexPath: IndexPath) {
        entries[indexPath.section].entries[indexPath.row].indexPath = indexPath
    }
}

// Conversion
extension SettingsTableData {
    func indexPath(for idPath: IdPath) -> IndexPath? {
        if let sectionIndex = entries.firstIndex(where: {$0.id == idPath.section}) {
            if let cellIndex = entries[sectionIndex].entries.firstIndex(where: {$0.id == idPath.cell}) {
                return IndexPath(row: cellIndex, section: sectionIndex)
            }
        }
        return nil
    }
}
