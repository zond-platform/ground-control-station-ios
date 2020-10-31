//
//  LocatorButton.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 05.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum LocatorButtonId: Int {
    case focus
    case user
    case aircraft
    case home

    var image: UIImage {
        switch self {
            case .focus:
                return #imageLiteral(resourceName: "buttonLocatorObject")
            case .user:
                return #imageLiteral(resourceName: "buttonLocatorObject")
            case .aircraft:
                return #imageLiteral(resourceName: "buttonLocatorObject")
            case .home:
                return #imageLiteral(resourceName: "buttonLocatorHome")
        }
    }

    var color: UIColor {
        switch self {
            case .focus:
                return UIColor.white
            case .user:
                return Colors.secondary
            case .aircraft:
                return Colors.error
            case .home:
                return UIColor.white
        }
    }
}

extension LocatorButtonId : CaseIterable {}

class LocatorButton : UIButton {
    var id: LocatorButtonId? {
        didSet {
            if let id = id {
                setImage(currentImage?.color(id.color), for: .normal)
            }
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ id: LocatorButtonId) {
        super.init(frame: CGRect())
        self.id = id
        setImage(id.image.color(id.color), for: .normal)
        backgroundColor = Colors.primary
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Dimensions.tileSize),
            widthAnchor.constraint(equalToConstant: Dimensions.tileSize)
        ])
    }
}
