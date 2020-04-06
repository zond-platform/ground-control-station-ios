//
//  SelectorView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 03.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

protocol SelectorViewDelegate : AnyObject {
    func tabSelected(_ itemName: SelectorItemName)
}

class SelectorView : UIView {
    weak var delegate: SelectorViewDelegate?
    private var buttons: [SelectorButton] = []
    private var views: [SelectorItemView] = []

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(frame: CGRect())
        for name in SelectorItemName.allCases {
            // Selector buttons
            buttons.append(SelectorButton(name))
            buttons.last!.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
            buttons.last!.titleLabel?.font = UIFont(name: "Courier", size: 12)
            buttons.last!.setTitle(String(describing: name), for: .normal)
            buttons.last!.setTitleColor(UIColor.white, for: .normal)
            buttons.last!.setTitleColor(UIColor.red, for: .selected)
            buttons.last!.addTarget(self, action: #selector(onButtonPress(_:)), for: .touchDown)
            addSubview(buttons.last!)
            // Associated views
            views.append(SelectorItemView(name))
            views.last!.isHidden = true
            addSubview(views.last!)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let viewWidth = superview?.frame.width ?? 0
        let viewHeight = superview?.frame.height ?? 0
        frame = CGRect(
            x: 0,
            y: 0,
            width: viewWidth,
            height: viewHeight
        )
        // Align selector buttons in a line
        alignViews(&buttons,
                   withLayout: .horizontal,
                   within: CGRect(
                       x: 0,
                       y: 0,
                       width: viewWidth,
                       height: viewHeight * 0.1
                   ))
        // Assign associated views with identical frame
        for view in views {
            view.frame = CGRect(
                x: 0,
                y: viewHeight * 0.1,
                width: viewWidth,
                height: viewHeight * 0.9
            )
        }
    }
}

// Public methods
extension SelectorView {
    @objc func onButtonPress(_ sender: SelectorButton) {
        delegate?.tabSelected(sender.name)
    }
    
    func presentView(_ itemName: SelectorItemName) {
        for i in 0..<SelectorItemName.allCases.count {
            // Select respective selector button
            buttons[i].name == itemName ? buttons[i].setSelected(!buttons[i].isSelected)
                                        : buttons[i].setSelected(false)
            // Show respective associated view
            views[i].isHidden = views[i].name == itemName
                                ? !views[i].isHidden
                                : true
        }
    }
    
    func assignViews(_ subviews: [UIView], forItem itemName: SelectorItemName) {
        for view in views {
            if view.name == itemName {
                view.assignViews(subviews)
            }
        }
    }
}
