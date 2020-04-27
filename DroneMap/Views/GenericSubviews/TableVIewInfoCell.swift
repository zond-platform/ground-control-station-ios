//
//  TableVIewInfoCell.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 27.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class TableViewInfoCell : UITableViewCell {
    private let stackView = UIStackView()
    private let title = InsetLabel()
    private let value = InsetLabel()

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

        value.font = AppFont.smallFont
        value.textColor = AppColor.Text.detailTitle
        stackView.addArrangedSubview(value)

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
extension TableViewInfoCell {
    func setup(_ name: String, _ value: String, _ enabled: Bool) {
        self.title.text = name
        self.value.text = value
        self.title.textColor = enabled ? AppColor.Text.mainTitle : AppColor.Text.inactiveTitle
        self.value.textColor = enabled ? AppColor.Text.detailTitle : AppColor.Text.inactiveTitle
    }
}
