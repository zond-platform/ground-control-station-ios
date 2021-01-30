//
//  CommandButton.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 11.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum CommandButtonId: Int {
    case start
    case pause
    case resume
    case stop
    case home

    var image: UIImage {
        switch self {
            case .start:
                return #imageLiteral(resourceName: "buttonCommandStart")
            case .pause:
                return #imageLiteral(resourceName: "buttonCommandPause")
            case .resume:
                return #imageLiteral(resourceName: "buttonCommandResume")
            case .stop:
                return #imageLiteral(resourceName: "buttonCommandStop")
            case .home:
                return #imageLiteral(resourceName: "buttonCommandGoHome")
        }
    }

    var color: UIColor {
        switch self {
            case .start:
                return UIColor.white
            case .pause:
                return UIColor.white
            case .resume:
                return UIColor.white
            case .stop:
                return Colors.error
            case .home:
                return UIColor.white
        }
    }
}

extension CommandButtonId : CaseIterable {}

class CommandButton : UIButton {
    // Stored properties
    var id: CommandButtonId? {
        didSet {
            if let id = id {
                setImage(id.image.color(id.color), for: .normal)
            }
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ id: CommandButtonId) {
        super.init(frame: CGRect())
        self.id = id
        setImage(id.image, for: .normal)
        backgroundColor = Colors.primary
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Dimensions.tileSize),
            widthAnchor.constraint(equalToConstant: Dimensions.tileSize)
        ])
    }
}
