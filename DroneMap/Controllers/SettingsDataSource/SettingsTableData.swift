//
//  SettingsData.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 20.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class SettingsTableData {
    private(set) var sections: [SettingsSectionData]

    init(_ sections: [SettingsSectionData]) {
        self.sections = sections
    }
}

// Private methods
extension SettingsTableData {
    func indexPath(for idPath: SettingsIdPath) -> IndexPath? {
        if let sectionIndex = sections.firstIndex(where: {$0.id == idPath.section}) {
            if let cellIndex = sections[sectionIndex].rows.firstIndex(where: {$0.id == idPath.row}) {
                return IndexPath(row: cellIndex, section: sectionIndex)
            }
        }
        return nil
    }
}

// Public methods
extension SettingsTableData {
    func idPath(for indexPath: IndexPath) -> SettingsIdPath {
        return sections[indexPath.section].rows[indexPath.row].idPath!
    }

    func rowData(at indexPath: IndexPath) -> SettingsRowData<Any> {
        return sections[indexPath.section].rows[indexPath.row]
    }

    func updateRow<ValueType>(at idPath: SettingsIdPath, with value: ValueType) {
        if let indexPath = self.indexPath(for: idPath) {
            sections[indexPath.section].rows[indexPath.row].value = value
            sections[indexPath.section].rows[indexPath.row].updateDisplayedData?()
        }
    }

    func enableRow(at idPath: SettingsIdPath, _ enable: Bool) {
        if let indexPath = self.indexPath(for: idPath) {
            sections[indexPath.section].rows[indexPath.row].isEnabled = enable
            sections[indexPath.section].rows[indexPath.row].updateDisplayedData?()
        }
    }
}
