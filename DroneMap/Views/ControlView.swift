//
//  ControlButtonsView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 14.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

protocol ControlViewDelegate : AnyObject {
    func buttonPressed(_ id: ControlButtonId)
}

class ControlView : UIView {
    private let stackView = UIStackView()
    private var buttons: [ControlButton] = []
    private var delegates: [ControlViewDelegate?] = []

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect(
            x: AppDimensions.Controls.x,
            y: AppDimensions.Controls.y,
            width: AppDimensions.Controls.width,
            height: AppDimensions.Controls.height
        ))

        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center

        for id in ControlButtonId.allCases {
            buttons.append(ControlButton(id))
            buttons.last!.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)
            NSLayoutConstraint.activate([
                buttons.last!.heightAnchor.constraint(equalToConstant: AppDimensions.Controls.height)
            ])
            stackView.addArrangedSubview(buttons.last!)
        }

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
}

// Public methods
extension ControlView {
    func addDelegate(_ delegate: ControlViewDelegate) {
        delegates.append(delegate)
    }
}

// Handle control events
extension ControlView {
    @objc func onButtonPressed(_ sender: ControlButton) {
        for delegate in self.delegates {
            delegate?.buttonPressed(sender.id)
        }
    }
}
