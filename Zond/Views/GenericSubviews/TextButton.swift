//
//  TextButton.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 07.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class TextButton : UIButton {
    // Stored properties
    var id: Int?
    var selectedColor = Colors.Overlay.simulatorActiveColor

    // Observer properties
    override var isSelected: Bool {
        didSet {
            setTitleColor(isSelected ? selectedColor : Colors.Text.inactiveTitle, for: .normal)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ selectedColor: UIColor) {
        super.init(frame: CGRect())
        setTitleColor(Colors.Text.inactiveTitle, for: .normal)
        backgroundColor = Colors.Overlay.primaryColor
        titleLabel!.font = Fonts.boldTitleFont
        self.selectedColor = selectedColor
    }

    convenience init(_ id: Int, _ selectedColor: UIColor) {
        self.init(selectedColor)
        self.id = id
    }
}
