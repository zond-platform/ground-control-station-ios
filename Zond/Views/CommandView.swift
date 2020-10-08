//
//  CommandView.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 08.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum CommandButtonId: Int {
    case start
    case pause
    case resume
    case stop

    var title: String {
        switch self {
            case .start:
                return "Start"
            case .pause:
                return "Pause"
            case .resume:
                return "Resume"
            case .stop:
                return "Stop"
        }
    }
}

extension CommandButtonId : CaseIterable {}

class CommandView : UIView {
    // Stored properties
    private let stackView = UIStackView()
    private var buttons: [TextButton] = []

    // Computed properties
    private var x: CGFloat {
        return Dimensions.spacer
    }
    private var y: CGFloat {
        return Dimensions.screenHeight * CGFloat(0.5) - Dimensions.tileSize
    }
    private var width: CGFloat {
        return Dimensions.simulatorButtonWidth
    }
    private var height: CGFloat {
        return Dimensions.tileSize * CGFloat(2)
    }

    // Notifyer properties
    var buttonPressed: ((_ id: CommandButtonId) -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect())
        frame = CGRect(
            x: -width,
            y: y,
            width: width,
            height: height
        )

        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center

        for id in [CommandButtonId.start, CommandButtonId.stop] {
            buttons.append(TextButton(id.rawValue, Colors.Overlay.userLocationColor))
            buttons.last!.setTitle(id.title, for: .normal)
            buttons.last!.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)
            NSLayoutConstraint.activate([
                buttons.last!.widthAnchor.constraint(equalToConstant: Dimensions.simulatorButtonWidth),
                buttons.last!.heightAnchor.constraint(equalToConstant: Dimensions.tileSize)
            ])
            stackView.addArrangedSubview(buttons.last!)
            stackView.setCustomSpacing(Dimensions.spacer, after: buttons.last!)
        }

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)
    }
}

// Public methods
extension CommandView {
    func showFromSide(_ show: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin.x = show ? self.x : -self.width
        })
    }
}

// Handle control events
extension CommandView {
    @objc func onButtonPressed(_ sender: TextButton) {
        if let rawSenderId = sender.id {
            if let senderId = CommandButtonId(rawValue: rawSenderId) {
                buttonPressed?(senderId)
            }
        }
    }
}
