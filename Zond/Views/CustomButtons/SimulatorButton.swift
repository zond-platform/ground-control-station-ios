//
//  SimulatorButton.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 07.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class SimulatorButton : UIButton {
    override var isSelected: Bool {
        didSet {
            setTitleColor(isSelected ? Colors.success
                                     : Colors.inactive,
                          for: .normal)
            setTitle(isSelected ? "Simulator On" : "Simulator Off", for: .normal)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect())
        backgroundColor = Colors.primary
        titleLabel!.font = Fonts.boldTitle
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Dimensions.tileSize),
            widthAnchor.constraint(equalToConstant: Dimensions.simulatorButtonWidth)
        ])
    }
}
