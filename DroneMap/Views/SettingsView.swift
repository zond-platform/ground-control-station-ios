//
//  SettingsView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 5/25/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class SettingsView : UIView {
    private var stackView = UIStackView()
    private var button = UIButton()
    var tableView = UITableView(frame: CGRect(), style: .grouped)

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect(
            x: AppDimensions.Settings.x,
            y: AppDimensions.Settings.y,
            width: AppDimensions.Settings.width,
            height: AppDimensions.Settings.buttonHeight
        ))

        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .top

        button.backgroundColor = AppColor.Overlay.semiTransparent
        button.setTitleColor(AppColor.Text.mainTitle, for: .normal)
        button.setTitle("Settings", for: .normal)
        button.titleLabel!.font = AppFont.smallFont
        button.addTarget(self, action: #selector(showSettings(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: AppDimensions.Settings.buttonHeight),
            button.widthAnchor.constraint(equalToConstant: AppDimensions.Settings.width)
        ])
        stackView.addArrangedSubview(button)

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

// Handle control events
extension SettingsView {
    @objc func showSettings(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.frame.size.height = sender.isSelected
                                     ? AppDimensions.Settings.height
                                     : AppDimensions.Settings.buttonHeight
            self.layoutIfNeeded()
        })
    }
}
