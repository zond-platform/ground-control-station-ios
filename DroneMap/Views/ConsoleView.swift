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
    private var label = Label()

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

        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center

        label.backgroundColor = AppColor.primaryColor
        label.font = AppFont.smallFont
        label.textColor = AppColor.Text.mainTitle
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: AppDimensions.ConsoleView.height),
            label.widthAnchor.constraint(equalToConstant: AppDimensions.ConsoleView.width)
        ])
        stackView.addArrangedSubview(label)

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// Public methods
extension ConsoleView {
    func logMessage(_ message: String, _ type: OSLogType) {
        os_log("%@", type: type, message)
        label.text = message
        switch type {
            case .debug:
                label.textColor = AppColor.Text.success
            case .error:
                label.textColor = AppColor.Text.error
            default:
                break
        }
    }
}
