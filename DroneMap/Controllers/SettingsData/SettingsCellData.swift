//
//  SettingsCellData.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 08.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

class SettingsCellData<ValueType> {
    let id: CellId
    let type: CellType
    let title: String
    var enabled: Bool
    var value: ValueType

    init(id: CellId, type: CellType, enabled: Bool, value: ValueType) {
        self.id = id
        self.type = type
        self.title = id.title
        self.enabled = enabled
        self.value = value
    }
}
