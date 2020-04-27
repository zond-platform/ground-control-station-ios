//
//  TableViewButtonCell.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 27.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class TableViewButtonCell : UITableViewCell {
    private let title = InsetLabel()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .gray
        accessoryType = .none
        backgroundColor = .clear

        title.font = AppFont.smallFont
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(title)
        NSLayoutConstraint.activate([
            title.leftAnchor.constraint(equalTo: leftAnchor),
            title.rightAnchor.constraint(equalTo: rightAnchor),
            title.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// Public methods
extension TableViewButtonCell {
    func setup(_ name: String, _ enabled: Bool) {
        self.title.text = name
        self.title.textColor = enabled ? UIColor.blue : AppColor.Text.inactiveTitle
        self.isUserInteractionEnabled = enabled
    }
}
