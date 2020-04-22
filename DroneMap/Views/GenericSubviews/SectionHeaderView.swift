//
//  SectionHeaderView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 17.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {
    let title = UILabel()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        title.font = AppFont.normalFont
        title.textColor = .gray
        title.sizeToFit()
        title.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(title)
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            title.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
}
