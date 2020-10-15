//
//  LocatorView.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 14.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class LocatorView : UIView {
    // Stored properties
    private let stackView = UIStackView()
    private let locateObjectButton = LocatorButton(.focus)
    private let locateHomeButton = LocatorButton(.home)

    // Computed properties
    private var x: CGFloat {
        return Dimensions.screenWidth - Dimensions.tileSize - Dimensions.spacer
    }
    private var y: CGFloat {
        return Dimensions.screenHeight * CGFloat(0.5) - Dimensions.tileSize - Dimensions.spacer * CGFloat(0.5)
    }
    private var width: CGFloat {
        return Dimensions.tileSize
    }
    private var height: CGFloat {
        return Dimensions.tileSize * CGFloat(2) + Dimensions.tileSize
    }

    // Notifyer properties
    var buttonPressed: ((_ id: LocatorButtonId) -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect())
        frame = CGRect(
            x: x,
            y: y,
            width: width,
            height: height
        )

        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center

        locateObjectButton.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)
        locateHomeButton.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)

        stackView.addArrangedSubview(locateObjectButton)
        stackView.setCustomSpacing(Dimensions.spacer, after: locateObjectButton)
        stackView.addArrangedSubview(locateHomeButton)

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)
    }
}

// Public methods
extension LocatorView {
    func setLocateObjectButtonId(_ id: LocatorButtonId) {
        locateObjectButton.id = id
    }
}

// Handle control events
extension LocatorView {
    @objc func onButtonPressed(_ sender: LocatorButton) {
        if let senderId = sender.id {
            buttonPressed?(senderId)
        }
    }
}
