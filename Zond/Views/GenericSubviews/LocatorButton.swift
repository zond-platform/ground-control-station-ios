//
//  LocatorButton.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 05.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum LocatorButtonId: Int {
    case user
    case aircraft

    var image: UIImage {
        switch self {
            case .user:
                return #imageLiteral(resourceName: "userBtn")
            case .aircraft:
                return #imageLiteral(resourceName: "aircraftBtn")
        }
    }

    var color: UIColor {
        switch self {
            case .user:
                return Colors.user
            case .aircraft:
                return Colors.aircraft
        }
    }
}

extension LocatorButtonId : CaseIterable {}

class LocatorButton : UIButton {
    // Stored properties
    var id: LocatorButtonId?

    // Observer properties
    override var isSelected: Bool {
        didSet {
            setImage(currentImage?.color(isSelected && id != nil ? id!.color
                                                                 : UIColor.white),
                     for: .normal)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ id: LocatorButtonId) {
        super.init(frame: CGRect())
        self.id = id
        setImage(id.image.color(UIColor.white), for: .normal)
        backgroundColor = Colors.primary
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Dimensions.tileSize),
            widthAnchor.constraint(equalToConstant: Dimensions.tileSize)
        ])
    }
}
