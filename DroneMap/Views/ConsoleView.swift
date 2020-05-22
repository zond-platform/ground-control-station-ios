//
//  ConsoleView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 18.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import os.log

import UIKit

class ConsoleView : UIView {
    private var stackView = UIStackView()
    private var timeStampLabel = Label()
    private var messageLabel = Label()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect(
            x: AppDimensions.ConsoleView.x,
            y: AppDimensions.ConsoleView.y,
            width: AppDimensions.ConsoleView.width,
            height: AppDimensions.ConsoleView.height
        ))
        
        backgroundColor = AppColor.primaryColor

        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center

//        timeStampLabel.font = AppFont.smallFont
//        timeStampLabel.textColor = AppColor.Text.mainTitle
//        NSLayoutConstraint.activate([
//            timeStampLabel.widthAnchor.constraint(equalToConstant: AppDimensions.ConsoleView.timeStampWidth)
//        ])
//        stackView.addArrangedSubview(timeStampLabel)

        messageLabel.font = AppFont.smallFont
        messageLabel.textColor = AppColor.Text.mainTitle
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
