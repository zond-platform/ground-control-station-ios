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
    private let menuButton = MenuButton()
    private let stackView = UIStackView()
    private let y = CGFloat(0)
    private let height = Dimensions.tileSize

    // Notifyer properties
    var menuButtonPressed: (() -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect(
            x: 0,
            y: y,
            width: Dimensions.screenWidth,
            height: Dimensions.tileSize
        ))

        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center

        menuButton.addTarget(self, action: #selector(onMenuButtonPressed(_:)), for: .touchUpInside)
        menuButton.isSelected = false

        stackView.addArrangedSubview(menuButton)
        stackView.addArrangedSubview(Environment.consoleViewController.view)
        stackView.addArrangedSubview(Environment.staticTelemetryViewController.view)

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: widthAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// Public methods
extension StatusView {
    func toggleShowFromTop(_ show: Bool) {
        frame.origin.y = show ? y : -height
    }
}

// Handle control events
extension StatusView {
    @objc func onMenuButtonPressed(_: LocatorButton) {
        menuButtonPressed?()
    }
}
