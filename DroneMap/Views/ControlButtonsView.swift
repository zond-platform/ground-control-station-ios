//
//  ControlButtonsView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 14.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

protocol ControlButtonsViewDelegate : AnyObject {
    func buttonPressed(_ id: ControlButtonId)
    func animationCompleted()
}

class ControlButtonsView : UIView {
    private var stackView = UIStackView()
    private var buttons: [ControlButton] = []
    private var delegates: [ControlButtonsViewDelegate?] = []

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect(
            x: AppDimensions.Controls.x,
            y: AppDimensions.Controls.y,
            width: AppDimensions.Controls.width,
            height: 0
        ))

        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .top

        for id in ControlButtonId.allCases {
            buttons.append(ControlButton(id))
            buttons.last!.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)
            NSLayoutConstraint.activate([
                buttons.last!.widthAnchor.constraint(equalToConstant: AppDimensions.Controls.width)
            ])
            stackView.addArrangedSubview(buttons.last!)
        }

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// Public methods
extension ControlButtonsView {
    func addDelegate(_ delegate: ControlButtonsViewDelegate) {
        delegates.append(delegate)
    }

    func show(_ show: Bool) {
        layoutIfNeeded()
        UIView.animate(withDuration: 0.3,
            animations: {
                if show {
                    self.frame.size.height = AppDimensions.Controls.height
                } else {
                    self.frame.size.height = 0
                }
                self.layoutIfNeeded()
            },
            completion: { _ in
                for delegate in self.delegates {
                    delegate?.animationCompleted()
                }
            })
    }
}

// Handle control events
extension ControlButtonsView {
    @objc func onButtonPressed(_ sender: ControlButton) {
        for delegate in self.delegates {
            delegate?.buttonPressed(sender.id)
        }
    }
}
