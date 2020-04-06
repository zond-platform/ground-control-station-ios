//
//  SelectorItem.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 04.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum SelectorItemName {
    case mission
    case status
}

extension SelectorItemName : CaseIterable {}

class SelectorButton : UIButton {
    var name: SelectorItemName!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(_ name: SelectorItemName) {
        super.init(frame: CGRect())
        self.name = name
    }
}

// Public methods
extension SelectorButton {
    func setSelected(_ selected: Bool) {
        isSelected = selected
    }
}
