//
//  TableView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/22/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum TableViewStyle {
    case status
    case console
}

/*************************************************************************************************/
class TableView : UITableView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(_ style: TableViewStyle) {
        super.init(frame: CGRect(), style: .plain)
        setStyle(style)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        frame = CGRect(
            x: 0,
            y: 0,
            width: superview!.frame.width,
            height: superview!.frame.height
        )
    }
    
    private func setStyle(_ style: TableViewStyle) {
        separatorStyle = .none
        rowHeight = 16
        contentInset.top = 10
        contentInset.bottom = 10
        switch style {
            case .status:
                backgroundColor = UIColor(white: 0.0, alpha: 0.6)
                isScrollEnabled = false
            case .console:
                backgroundColor = UIColor(white: 0.2, alpha: 0.6)
        }
    }
}

/*************************************************************************************************/
class TableViewCell: UITableViewCell {
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
        setStyle()
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
    
    private func setStyle() {
        setFont(UIFont(name: "Courier", size: 12)!)
        setTextColor(UIColor.white)
        setClearBackground()
        contextLabel.textAlignment = .right
        contentView.addSubview(contextLabel)
        contentView.addSubview(messageLabel)
        selectionStyle = .none
    }
    
    private func setFont(_ font: UIFont) {
        contextLabel.font = font
        messageLabel.font = font
    }
    
    private func setClearBackground() {
        backgroundColor = UIColor.clear
        contextLabel.backgroundColor = UIColor.clear
        messageLabel.backgroundColor = UIColor.clear
    }
    
    func setTextColor(_ color: UIColor) {
        contextLabel.textColor = color
        messageLabel.textColor = color
    }
}
