//
//  ControlButtonsView.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 14.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class NavigationView : UIView {
    // Static properties
    static let width = Dimensions.ContentView.width * Dimensions.ContentView.Ratio.h[2]

    // Stored properties
    private let stackView = UIStackView()
    private var buttons: [NavigationButton] = []

    // Computed properties
    private var xOffset: CGFloat {
        return Dimensions.ContentView.width * (Dimensions.ContentView.Ratio.h[0] + Dimensions.ContentView.Ratio.h[1])
    }
    private var buttonHeight: CGFloat {
        return Dimensions.ContentView.height * Dimensions.ContentView.Ratio.v[0]
    }
    private var height: CGFloat {
        return buttonHeight * CGFloat(NavigationButtonId.allCases.count)
    }

    // Notifyer properties
    var buttonSelected: ((_ id: NavigationButtonId, _ isSelected: Bool) -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect())
        frame = CGRect(
            x: Dimensions.ContentView.x + xOffset,
            y: Dimensions.ContentView.y,
            width: NavigationView.width,
            height: height
        )

        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center

        for id in NavigationButtonId.allCases {
            buttons.append(NavigationButton(id))
            buttons.last!.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)
            NSLayoutConstraint.activate([
                buttons.last!.heightAnchor.constraint(equalToConstant: buttonHeight),
                buttons.last!.widthAnchor.constraint(equalToConstant: NavigationView.width)
            ])
            stackView.addArrangedSubview(buttons.last!)
        }

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)
    }
}

// Public methods
extension NavigationView {
    func deselectButton(with id: NavigationButtonId) {
        for button in buttons {
            if button.id == id {
                button.isSelected = false
            }
        }
    }
}

// Handle control events
extension NavigationView {
    @objc func onButtonPressed(_ sender: NavigationButton) {
        sender.isSelected = !sender.isSelected
        buttonSelected?(sender.id, sender.isSelected)
    }
}
