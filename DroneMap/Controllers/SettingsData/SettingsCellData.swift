//
//  SettingsCellData.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 08.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

class SettingsCellData<ValueType> {
    var id: CellId
    var type: CellType
    var title: String
    var value: ValueType

    init(id: CellId, type: CellType, value: ValueType) {
        self.id = id
        self.type = type
        self.title = id.title
        self.value = value
    }
}
