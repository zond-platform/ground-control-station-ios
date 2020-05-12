//
//  ControlButtonsView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 14.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class NavigationView : UIView {
    private let stackView = UIStackView()
    private var buttons: [NavigationButton] = []
    var buttonSelected: ((_ id: NavigationButtonId, _ isSelected: Bool) -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect(
            x: AppDimensions.NavigationView.x,
            y: AppDimensions.NavigationView.y,
            width: AppDimensions.NavigationView.width,
            height: AppDimensions.NavigationView.height
        ))

        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = AppDimensions.NavigationView.Spacer.height

        for id in NavigationButtonId.allCases {
            buttons.append(NavigationButton(id))
            buttons.last!.addTarget(self, action: #selector(onButtonPressed(_:_:)), for: .touchUpInside)
            NSLayoutConstraint.activate([
                buttons.last!.heightAnchor.constraint(equalToConstant: AppDimensions.NavigationView.Button.height),
                buttons.last!.widthAnchor.constraint(equalToConstant: AppDimensions.NavigationView.width)
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
    @objc func onButtonPressed(_ sender: NavigationButton, _ event: UIEvent) {
        sender.isSelected = !sender.isSelected
        buttonSelected?(sender.id, sender.isSelected)
    }
}
