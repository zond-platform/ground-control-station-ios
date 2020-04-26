//
//  TabView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 18.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import os.log

import UIKit

protocol TabViewDelegate : AnyObject {
    func buttonSelected(_ id: TabButtonId, _ selected: Bool)
}

class TabView : UIView {
    private var stackView = UIStackView()
    private var buttons: [TabButton] = []
    private var delegates: [TabViewDelegate?] = []

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

        for id in TabButtonId.allCases {
            buttons.append(TabButton(id))
            buttons.last!.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)
            NSLayoutConstraint.activate([
                buttons.last!.heightAnchor.constraint(equalToConstant: AppDimensions.Tab.height),
                buttons.last!.widthAnchor.constraint(equalToConstant: id.width)
            ])
            stackView.addArrangedSubview(buttons.last!)
        }

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// Handle control events
extension TabView {
    @objc func onButtonPressed(_ sender: TabButton) {
        sender.isSelected = !sender.isSelected
        for delegate in self.delegates {
            delegate?.buttonSelected(sender.id, sender.isSelected)
        }
    }
}

// Private methods
extension TabView {
    func selectButton(_ id: TabButtonId) {}
}

// Public methods
extension TabView {
    func addDelegate(_ delegate: TabViewDelegate) {
        delegates.append(delegate)
    }

    func logMessage(_ message: String, _ type: OSLogType) {
        os_log("%@", type: type, message)
        for button in buttons {
            if button.id == .console {
                button.setTitle(message, for: .normal)
                switch type {
                    case .debug:
                        button.setTitleColor(AppColor.Text.success, for: .normal)
                    case .error:
                        button.setTitleColor(AppColor.Text.error, for: .normal)
                    default:
                        break
                }
            }
        }
    }

    func deselectButton() {}
}
