//
//  TableViewSwitchCell.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 27.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class TableViewSwitchCell : UITableViewCell {
    private let stackView = UIStackView()
    private let title = InsetLabel()
    private let switcher = SettingsCellSwitch()
    var switchTriggered: ((_ idPath: SettingsIdPath, _ isOn: Bool) -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        accessoryType = .none
        backgroundColor = .clear

        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center

        title.font = AppFont.smallFont
        stackView.addArrangedSubview(title)

        stackView.addArrangedSubview(switcher)

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
extension TableViewSwitchCell {
    func setup(_ data: SettingsRowData<Any>) {
        switcher.addTarget(self, action: #selector(switchTriggered(_:)), for: .valueChanged)
        switcher.idPath = data.idPath

        self.switcher.isUserInteractionEnabled = data.isEnabled
        self.switcher.isOn = data.value as? Bool ?? false

        self.title.text = data.title
        self.title.textColor = data.isEnabled ? AppColor.Text.mainTitle : AppColor.Text.inactiveTitle
    }
}

// Handle control events
extension TableViewSwitchCell {
    @objc func switchTriggered(_ sender: SettingsCellSwitch) {
        if let idPath = sender.idPath {
            switchTriggered?(idPath, sender.isOn)
        }
    }
}
