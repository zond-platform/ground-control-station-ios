//
//  SettingsView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 5/25/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

protocol SettingsViewDelegate : AnyObject {
    func animationCompleted()
}

class SettingsView : UIView {
    private var stackView = UIStackView()
    var tableView = UITableView(frame: CGRect(), style: .grouped)
    private var delegates: [SettingsViewDelegate?] = []

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect(
            x: AppDimensions.Settings.x,
            y: AppDimensions.Settings.y,
            width: AppDimensions.Settings.width,
            height: 0.0
        ))

        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .top

        tableView.separatorStyle = .none
        tableView.backgroundColor = AppColor.Overlay.semiTransparent
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalToConstant: AppDimensions.Settings.width)
        ])
        stackView.addArrangedSubview(tableView)

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// Public methods
extension SettingsView {
    func addDelegate(_ delegate: SettingsViewDelegate) {
        delegates.append(delegate)
    }

    func show(_ show: Bool) {
        layoutIfNeeded()
        UIView.animate(withDuration: 0.3,
            animations: {
                if show {
                    self.frame.size.height = AppDimensions.Settings.height
                } else {
                    self.frame.size.height = 0
                }
                self.layoutIfNeeded()
            },
            completion: { _ in
                for delegate in self.delegates {
                    delegate?.animationCompleted()
                }
            })
    }
}
