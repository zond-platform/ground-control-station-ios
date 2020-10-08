//
//  ConsoleView.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 18.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import os.log

import UIKit

class ConsoleView : UIView {
    private var stackView = UIStackView()
    private var messageLabel = InsetLabel()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect())

        backgroundColor = UIColor(red: 0.2588, green: 0.2863, blue: 0.2863, alpha: 0.7)

        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center

        messageLabel.font = Fonts.titleFont
        messageLabel.textColor = Colors.Text.mainTitle
        stackView.addArrangedSubview(messageLabel)

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Dimensions.tileSize),
            stackView.widthAnchor.constraint(equalTo: widthAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// Public methods
extension ConsoleView {
    func logMessage(_ message: String, _ type: OSLogType) {
        os_log("%@", type: type, message)
        messageLabel.text = message
    }
}
