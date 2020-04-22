//
//  TableSectionData.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 08.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

class TableSectionData {
    let id: SectionId
    let headerTitle: String
    let footerText: String
    var entries: [TableCellData<Any>]

    init(id: SectionId, entries: [TableCellData<Any>]) {
        self.id = id
        self.headerTitle = id.headerTitle
        self.footerText = id.footerText
        self.entries = entries
    }
}
