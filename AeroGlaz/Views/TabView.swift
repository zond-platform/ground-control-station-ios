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
    private var consoleLabel = UILabel()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect(
            x: AppDimensions.Tab.x,
            y: AppDimensions.Tab.y,
            width: AppDimensions.Tab.width,
            height: AppDimensions.Tab.height
        ))

        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center

        NSLayoutConstraint.activate([
            consoleLabel.heightAnchor.constraint(equalToConstant: AppDimensions.Tab.height),
            consoleLabel.widthAnchor.constraint(equalToConstant: AppDimensions.Tab.width)
        ])
        stackView.addArrangedSubview(consoleLabel)

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
        consoleLabel.text = message
        switch type {
            case .debug:
                consoleLabel.textColor = AppColor.Text.success
            case .error:
                consoleLabel.textColor = AppColor.Text.error
            default:
                break
        }
    }
}
