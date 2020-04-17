//
//  ButtonsView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 14.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

protocol ButtonsViewDelegate : AnyObject {
    func buttonPressed(_ id: ButtonId)
}

class ButtonsView : UIView {
    private var stackView = UIStackView()
    private var buttons: [ButtonId:Button] = [:]
    var delegates: [ButtonsViewDelegate?] = []

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect(
            x: AppDimensions.ButtonsView.x,
            y: AppDimensions.ButtonsView.y,
            width: AppDimensions.ButtonsView.width,
            height: AppDimensions.ButtonsView.height
        ))
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = AppDimensions.ButtonsView.Button.spacer
        for id in ButtonId.allCases {
            buttons[id] = Button(id)
            buttons[id]!.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)
            buttons[id]!.heightAnchor.constraint(equalToConstant: AppDimensions.ButtonsView.Button.size).isActive = true
            buttons[id]!.widthAnchor.constraint(equalToConstant: AppDimensions.ButtonsView.Button.size).isActive = true
            stackView.addArrangedSubview(buttons[id]!)
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}

// Public methods
extension ButtonsView {
    func addDelegate(_ delegate: ButtonsViewDelegate) {
        delegates.append(delegate)
    }
}

// Handle control events
extension ButtonsView {
    @objc func onButtonPressed(_ sender: Button) {
        for delegate in self.delegates {
            delegate?.buttonPressed(sender.id)
        }
    }
}
