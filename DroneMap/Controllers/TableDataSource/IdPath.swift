//
//  IdPath.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 25.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

struct IdPath {
    let section: SectionId
    let row: RowId

    init(_ sectionId: SectionId, _ rowId: RowId) {
        self.section = sectionId
        self.row = rowId
    }
}

func ==(lhs: IdPath, rhs: IdPath) -> Bool {
    return lhs.section == rhs.section
           && lhs.row == rhs.row
}

func ~=(pattern: IdPath, value: IdPath) -> Bool {
    return value == pattern
}
