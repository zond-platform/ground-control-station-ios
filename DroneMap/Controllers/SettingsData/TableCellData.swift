//
//  TableCellData.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 08.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum CellType {
    case button
    case info
    case slider
    case switcher

    var reuseIdentifier: String {
        switch self {
            case .button:
                return "buttonCell"
            case .info:
                return "infoCell"
            case .slider:
                return "sliderCell"
            case .switcher:
                return "switcherCell"
        }
    }
}

class TableCellData<ValueType> {
    let id: CellId
    let title: String
    let type: CellType

    var indexPath = IndexPath()
    var value: ValueType
    var isEnabled: Bool

    init(id: CellId, type: CellType, value: ValueType, isEnabled: Bool) {
        self.id = id
        self.title = id.title
        self.type = type
        self.value = value
        self.isEnabled = isEnabled
    }
}
