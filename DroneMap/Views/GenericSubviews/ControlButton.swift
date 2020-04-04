//
//  ControlButton.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 24.12.19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum ControlButtonName {
    case simulator
    case restart
    case mission
    case upload
    case start
    case stop
    case pause
    case resume
}

extension ControlButtonName : CaseIterable {}

class ControlButton : UIButton {
    var name: ControlButtonName!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(_ name: ControlButtonName) {
        super.init(frame: CGRect())
        self.name = name
    }
}

// Public methods
extension ControlButton {
    func setSelected(_ selected: Bool) {
        isSelected = selected
        backgroundColor = isSelected ? UIColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 0.8)
                                     : UIColor(white: 0.0, alpha: 0.6)
    }
}
