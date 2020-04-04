//
//  SelectorView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 03.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum SelectorButtonName {
    case mission
    case status
}

extension SelectorButtonName : CaseIterable {}

protocol SelectorViewDelegate : AnyObject {
    func tabSelected(_ tabName: String)
}

class SelectorView : UIView {
    weak var delegate: SelectorViewDelegate?
    private var buttons: [UIButton] = []

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(frame: CGRect())
        for name in SelectorButtonName.allCases {
            buttons.append(UIButton())
            addSubview(buttons.last!)
            buttons.last!.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
            buttons.last!.titleLabel?.font = UIFont(name: "Courier", size: 12)
            buttons.last!.setTitle(String(describing: name), for: .normal)
            buttons.last!.setTitleColor(UIColor.white, for: .normal)
            buttons.last!.setTitleColor(UIColor.red, for: .selected)
            buttons.last!.addTarget(self, action: #selector(onButtonPress(_:)), for: .touchDown)
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
        alignViews(&buttons,
                   withLayout: .horizontal,
                   within: CGSize(width: viewWidth, height: viewHeight))
    }
}

// Public methods
extension SelectorView {
    @objc func onButtonPress(_ sender: UIButton) {
        for button in buttons {
            button.isSelected = button == sender ? !sender.isSelected : false
        }
        delegate?.tabSelected(sender.currentTitle!)
    }
}
