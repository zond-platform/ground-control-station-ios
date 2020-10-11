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
    private var buttons: [LocatorButton] = []

    // Computed properties
    private var x: CGFloat {
        return Dimensions.screenWidth - Dimensions.tileSize - Dimensions.spacer
    }
    private var y: CGFloat {
        return Dimensions.screenHeight - (Dimensions.tileSize + Dimensions.spacer) * CGFloat(LocatorButtonId.allCases.count)
    }
    private var width: CGFloat {
        return Dimensions.tileSize
    }
    private var height: CGFloat {
        return Dimensions.tileSize * CGFloat(LocatorButtonId.allCases.count)
    }

    // Notifyer properties
    var buttonSelected: ((_ id: LocatorButtonId, _ isSelected: Bool) -> Void)?

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

        for id in LocatorButtonId.allCases {
            buttons.append(LocatorButton(id))
            buttons.last!.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)
            buttons.last!.isSelected = false
            stackView.addArrangedSubview(buttons.last!)
            stackView.setCustomSpacing(Dimensions.spacer, after: buttons.last!)
        }

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)
    }
}

// Public methods
extension LocatorView {
    func deselectButton(with id: LocatorButtonId) {
        if let i = buttons.firstIndex(where: { $0.id != nil && $0.id == id }) {
            buttons[i].isSelected = false
        }
    }
}

// Handle control events
extension LocatorView {
    @objc func onButtonPressed(_ sender: LocatorButton) {
        sender.isSelected = !sender.isSelected
        if let senderId = sender.id {
            buttonSelected?(senderId, sender.isSelected)
        }
    }
}
