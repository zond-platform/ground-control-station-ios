//
//  MenuButton.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 11.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class MenuButton : UIButton {
    override var isSelected: Bool {
        didSet {
            setImage(currentImage?.color(isSelected ? Colors.secondary
                                                    : UIColor.white),
                     for: .normal)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect())
        setImage(#imageLiteral(resourceName: "menuBtn").color(UIColor.white), for: .normal)
        backgroundColor = Colors.primary
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Dimensions.tileSize),
            widthAnchor.constraint(equalToConstant: Dimensions.tileSize)
        ])
    }
}
