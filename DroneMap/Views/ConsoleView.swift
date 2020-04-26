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
    private var label = ConsoleLabel()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect(
            x: AppDimensions.Console.x,
            y: AppDimensions.Console.y,
            width: AppDimensions.Console.width,
            height: AppDimensions.Console.height
        ))

        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center

        label.backgroundColor = AppColor.Overlay.semiTransparent
        label.text = "Dummy text"
        label.font = AppFont.smallFont
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: AppDimensions.Console.height),
            label.widthAnchor.constraint(equalToConstant: AppDimensions.Console.width)
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
