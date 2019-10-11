//
//  ConsoleView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 5/25/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum TableViewStyle {
    case status
    case console
}

/*************************************************************************************************/
class ConsoleView : UIView {
    let statusViewHeight: CGFloat = 116.0
    private var statusView = UIView()
    private var consoleView = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(frame: CGRect())
    }
    
    func addSubviews(_ statusView: UIView,
                     _ consoleView: UIView) {
        self.statusView.addSubview(statusView)
        self.consoleView.addSubview(consoleView)
        addSubview(self.statusView)
        addSubview(self.consoleView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        statusView.frame = CGRect(
            x: 0,
            y: 0,
            width: frame.width,
            height: statusViewHeight
        )
        consoleView.frame = CGRect(
            x: 0,
            y: statusViewHeight,
            width: frame.width,
            height: frame.height - statusViewHeight
        )
    }
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
            width: superview?.frame.width ?? 0,
            height: superview?.frame.height ?? 0
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
