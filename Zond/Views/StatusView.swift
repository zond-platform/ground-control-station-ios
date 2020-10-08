//
//  StatusView.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 04.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class StatusView : UIView {
    // Stored properties
    private let menuButton = ImageButton(#imageLiteral(resourceName: "menuBtn"), Colors.Text.selectedTitle)
    private let stackView = UIStackView()
    private let simulatorButton = TextButton(Colors.Overlay.simulatorActiveColor)

    // Notifyer properties
    var menuButtonSelected: ((_ isSelected: Bool) -> Void)?
    var simulatorButtonSelected: ((_ isSelected: Bool) -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect(
            x: 0,
            y: 0,
            width: Dimensions.screenWidth,
            height: Dimensions.tileSize
        ))

        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center

        menuButton.addTarget(self, action: #selector(onMenuButtonPressed(_:)), for: .touchUpInside)
        simulatorButton.addTarget(self, action: #selector(onSimulatorButtonPressed(_:)), for: .touchUpInside)
        simulatorButton.setTitle("Simulator Off", for: .normal)

        stackView.addArrangedSubview(menuButton)
        stackView.addArrangedSubview(Environment.consoleViewController.view)
        stackView.addArrangedSubview(Environment.staticTelemetryViewController.view)
        stackView.addArrangedSubview(simulatorButton)

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)

        NSLayoutConstraint.activate([
            menuButton.heightAnchor.constraint(equalToConstant: Dimensions.tileSize),
            menuButton.widthAnchor.constraint(equalToConstant: Dimensions.tileSize),
            simulatorButton.heightAnchor.constraint(equalToConstant: Dimensions.tileSize),
            simulatorButton.widthAnchor.constraint(equalToConstant: Dimensions.simulatorButtonWidth),
            stackView.widthAnchor.constraint(equalTo: widthAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// Public methods
extension StatusView {
    func triggerSimulatorButtonSelection(_ select: Bool) {
        simulatorButton.isSelected = select
        simulatorButton.setTitle(select ? "Simulator On" : "Simulator Off", for: .normal)
    }
}

// Handle control events
extension StatusView {
    @objc func onMenuButtonPressed(_: ImageButton) {
        menuButton.isSelected = !menuButton.isSelected
        menuButtonSelected?(menuButton.isSelected)
    }

    @objc func onSimulatorButtonPressed(_: TextButton) {
        simulatorButtonSelected?(!simulatorButton.isSelected)
    }
}
