//
//  StatusView.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 04.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

fileprivate let x = CGFloat(0)
fileprivate let y = CGFloat(0)
fileprivate let width = Dimensions.screenWidth
fileprivate let height = Dimensions.tileSize

class StatusView : UIView {
    // Stored properties
    private let menuButton = MenuButton()
    private let stackView = UIStackView()

    // Notifyer properties
    var menuButtonPressed: (() -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect(
            x: x,
            y: y,
            width: width,
            height: height
        ))

        backgroundColor = Colors.primary

        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .leading

        menuButton.addTarget(self, action: #selector(onMenuButtonPressed(_:)), for: .touchUpInside)
        menuButton.isSelected = false

        stackView.addArrangedSubview(menuButton)
        stackView.setCustomSpacing(Dimensions.spacer, after: menuButton)
        stackView.addArrangedSubview(Environment.consoleViewController.view)
        stackView.addArrangedSubview(Environment.staticTelemetryViewController.view)

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimensions.safeAreaOffset),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Dimensions.safeAreaOffset),
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
