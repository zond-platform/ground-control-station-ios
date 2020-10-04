//
//  StatusView.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 04.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class StatusView : UIView {
    private var stackView = UIStackView()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect())

        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center

        stackView.addArrangedSubview(Environment.consoleViewController.view)
        stackView.setCustomSpacing(Dimensions.viewDivider, after: Environment.consoleViewController.view)
        stackView.addArrangedSubview(Environment.staticTelemetryViewController.view)

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: Dimensions.screenWidth),
            stackView.widthAnchor.constraint(equalTo: widthAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
