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

    func height(forHeaderIn section: Int) -> CGFloat {
        return entries[section].id.headerHeight
    }

    func height(forFooterIn section: Int) -> CGFloat {
        return entries[section].id.footerHeight
    }

    func title(forHeaderIn section: Int) -> String {
        return entries[section].headerTitle
    }

    func entry(at indexPath: IndexPath) -> SettingsCellData<Any> {
        return entries[indexPath.section].entries[indexPath.row]
    }

    func entry(at idPath: IdPath) -> SettingsCellData<Any>? {
        if let indexPath = self.indexPath(for: idPath) {
            return entries[indexPath.section].entries[indexPath.row]
        } else {
            return nil
        }
    }
}

// Modification
extension SettingsTableData {
    func updateEntry<ValueType>(at idPath: IdPath, with value: ValueType) -> SettingsCellData<Any>? {
        if let indexPath = self.indexPath(for: idPath) {
            entries[indexPath.section].entries[indexPath.row].value = value
            return entries[indexPath.section].entries[indexPath.row]
        } else {
            return nil
        }
    }

    func enableEntry(at idPath: IdPath, _ shouldEnable: Bool) -> SettingsCellData<Any>? {
        if let indexPath = self.indexPath(for: idPath) {
            entries[indexPath.section].entries[indexPath.row].isEnabled = shouldEnable
            return entries[indexPath.section].entries[indexPath.row]
        } else {
            return nil
        }
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
