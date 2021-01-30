//
//  MenuButton.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 11.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class MenuButton : UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect())
        setImage(#imageLiteral(resourceName: "buttonMenuShow").color(UIColor.white), for: .normal)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Dimensions.tileSize),
            widthAnchor.constraint(equalToConstant: Dimensions.tileSize)
        ])
    }
}
