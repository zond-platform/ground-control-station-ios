//
//  RowData.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 08.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum RowId {
    case gridDistance
    case gridAngle
    case shootDistance
    case altitude
    case flightSpeed
    case command

    var title: String {
        switch self {
            case .gridDistance:
                return "Grid Distance"
            case .gridAngle:
                return "Grid Angle"
            case .shootDistance:
                return "Shoot Distance"
            case .altitude:
                return "Altitude"
            case .flightSpeed:
                return "Flight Speed"
            case .command:
                return "Command"
        }
    }

    var unit: String? {
        switch self {
            case .gridDistance:
                return "m"
            case .gridAngle:
                return "°"
            case .shootDistance:
                return "m"
            case .altitude:
                return "m"
            case .flightSpeed:
                return "m/s"
            case .command:
                return nil
        }
    }
}

enum RowType {
    case command
    case slider

    var reuseIdentifier: String {
        switch self {
            case .command:
                return "commandCell"
            case .slider:
                return "sliderCell"
        }
    }
}

class RowData<ValueType> {
    private(set) var idPath: IdPath?
    let id: RowId
    let title: String
    let type: RowType
    var value: ValueType
    var isEnabled: Bool
    var updated: (() -> Void)?

    init(id: RowId, type: RowType, value: ValueType, isEnabled: Bool) {
        self.id = id
        self.title = id.title
        self.type = type
        self.value = value
        self.isEnabled = isEnabled
    }
}

// Public methods
extension RowData {
    func setIdPath(_ idPath: IdPath) {
        self.idPath = idPath
    }
}
