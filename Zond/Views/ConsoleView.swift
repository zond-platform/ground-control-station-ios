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
    // Static properties
    static var yOffset: CGFloat {
        return Dimensions.ContentView.height * Dimensions.ContentView.Ratio.v[1]
    }

    // Stored properties
    private var stackView = UIStackView()
    private var timeStampLabel = InsetLabel()
    private var messageLabel = InsetLabel()

    // Computed properties
    private var xOffset: CGFloat {
        return Dimensions.ContentView.width * Dimensions.ContentView.Ratio.h[0] + Dimensions.viewSpacer
    }
    private var width: CGFloat {
        return Dimensions.ContentView.width * (Dimensions.ContentView.Ratio.h[1] + Dimensions.ContentView.Ratio.h[2])
               - Dimensions.viewSpacer
    }
    private var height: CGFloat {
        return Dimensions.ContentView.height * Dimensions.ContentView.Ratio.v[0]
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect())
        frame = CGRect(
            x: Dimensions.ContentView.x + xOffset,
            y: Dimensions.ContentView.y + ConsoleView.yOffset,
            width: width,
            height: height
        )
        
        backgroundColor = Colors.Overlay.primaryColor

        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center

        messageLabel.font = Fonts.titleFont
        messageLabel.textColor = Colors.Text.mainTitle
        stackView.addArrangedSubview(messageLabel)

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
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
