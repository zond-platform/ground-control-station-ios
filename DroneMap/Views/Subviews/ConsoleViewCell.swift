//
//  ConsoleViewCell.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 26.12.19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class ConsoleViewCell : UITableViewCell {
    private let topMargin: CGFloat = 1
    private let leftMargin: CGFloat = 10
    private let contextLabelWidth: CGFloat = 40

    var contextLabel = UILabel()
    var messageLabel = UILabel()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contextLabel.backgroundColor = UIColor.clear
        contextLabel.textAlignment = .right
        contextLabel.font = UIFont(name: "Courier", size: 12)!
        contextLabel.textColor = UIColor.white
        messageLabel.backgroundColor = UIColor.clear
        messageLabel.font = UIFont(name: "Courier", size: 12)!
        messageLabel.textColor = UIColor.white
        selectionStyle = .none
        backgroundColor = UIColor.clear
        contentView.addSubview(contextLabel)
        contentView.addSubview(messageLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contextLabel.frame = CGRect(
            x: leftMargin,
            y: topMargin,
            width: contextLabelWidth,
            height: contentView.frame.height
        )
        messageLabel.frame = CGRect(
            x: contextLabelWidth + 2 * leftMargin,
            y: topMargin,
            width: contentView.frame.width - contextLabelWidth - 2 * leftMargin,
            height: contentView.frame.height
        )
    }
}

// Public methods
extension ConsoleViewCell {
    func setTextColor(_ color: UIColor) {
        contextLabel.textColor = color
        messageLabel.textColor = color
    }
}
