//
//  SettingsData.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 20.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class TableData {
    private(set) var sections: [SectionData]

    let rowHeight = MissionView.TableRow.height
    var contentHeight: CGFloat {
        var height = CGFloat(0)
        for section in sections {
            height += (section.id.headerHeight + section.id.footerHeight)
            for _ in section.rows {
                height += rowHeight
            }
        }
        return height
    }

    init(_ sections: [SectionData]) {
        self.sections = sections
    }
}

// Private methods
extension TableData {
    func indexPath(for idPath: IdPath) -> IndexPath? {
        if let sectionIndex = sections.firstIndex(where: {$0.id == idPath.section}) {
            if let cellIndex = sections[sectionIndex].rows.firstIndex(where: {$0.id == idPath.row}) {
                return IndexPath(row: cellIndex, section: sectionIndex)
            }
        }
        return nil
    }
}

// Public methods
extension TableData {
    func idPath(for indexPath: IndexPath) -> IdPath {
        return sections[indexPath.section].rows[indexPath.row].idPath!
    }

    func rowData(at indexPath: IndexPath) -> RowData<Any> {
        return sections[indexPath.section].rows[indexPath.row]
    }

    func rowValue(at idPath: IdPath) -> Any? {
        if let indexPath = self.indexPath(for: idPath) {
            return sections[indexPath.section].rows[indexPath.row].value
        } else {
            return nil
        }
    }

    func updateRow<ValueType>(at idPath: IdPath, with value: ValueType) {
        if let indexPath = self.indexPath(for: idPath) {
            let row = sections[indexPath.section].rows[indexPath.row]
            row.value = value
            row.updated?()
        }
    }

    func enableRow(at idPath: IdPath, _ enable: Bool) {
        if let indexPath = self.indexPath(for: idPath) {
            let row = sections[indexPath.section].rows[indexPath.row]
            row.isEnabled = enable
            row.updated?()
        }
    }
}
