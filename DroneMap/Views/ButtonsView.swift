//
//  ButtonsView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 14.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class ButtonsView : UIView {
    private var stackView = UIStackView()
    private var buttons: [ButtonId:Button] = [:]

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(frame: CGRect())

        stackView.axis = .vertical;
        stackView.distribution = .equalSpacing;
        stackView.alignment = .center;
        stackView.spacing = 30;
        for id in ButtonId.allCases {
            buttons[id] = Button(id)
            stackView.addArrangedSubview(buttons[id]!)
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
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
