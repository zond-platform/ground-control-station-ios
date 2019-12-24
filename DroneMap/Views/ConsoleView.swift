//
//  ConsoleView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 5/25/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class ConsoleView : UITableView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(frame: CGRect(), style: .plain)
        separatorStyle = .none
        rowHeight = 16
        contentInset.top = 10
        contentInset.bottom = 10
        backgroundColor = UIColor(white: 0.2, alpha: 0.6)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        frame = CGRect(
            x: 0,
            y: 0,
            width: superview?.frame.width ?? 0,
            height: superview?.frame.height ?? 0
        )
    }
}

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

    func setTextColor(_ color: UIColor) {
        contextLabel.textColor = color
        messageLabel.textColor = color
    }
}
