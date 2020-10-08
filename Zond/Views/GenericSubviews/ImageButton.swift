//
//  ImageButton.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 05.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class ImageButton : UIButton {
    // Stored properties
    var id: Int?
    var selectedColor = Colors.Text.mainTitle

    // Observer properties
    override var isSelected: Bool {
        didSet {
            setImage(currentImage?.color(isSelected ? selectedColor : Colors.Text.mainTitle), for: .normal)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ image: UIImage, _ selectedColor: UIColor) {
        super.init(frame: CGRect())
        setImage(image.color(Colors.Text.mainTitle), for: .normal)
        backgroundColor = Colors.Overlay.primaryColor
        titleLabel!.font = Fonts.titleFont
        self.selectedColor = selectedColor
    }

    convenience init(_ id: Int, _ image: UIImage, _ selectedColor: UIColor) {
        self.init(image, selectedColor)
        self.id = id
    }
}
