//
//  CommandView.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 08.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class CommandView : UIView {
    // Stored properties
    private let stackView = UIStackView()
    private var startButton = CommandButton(.start)
    private var homeButton = CommandButton(.home)
    private var stopButton = CommandButton(.stop)

    // Computed properties
    private var x: CGFloat {
        return Dimensions.roundedAreaOffsetOr(Dimensions.spacer)
    }
    private var y: CGFloat {
        return Dimensions.screenHeight * CGFloat(0.5) - Dimensions.tileSize - Dimensions.separator * CGFloat(0.5)
    }
    private var width: CGFloat {
        return Dimensions.tileSize
    }
    private var height: CGFloat {
        return Dimensions.tileSize * CGFloat(3) + Dimensions.separator * CGFloat(2)
    }

    // Notifyer properties
    var buttonPressed: ((_ id: CommandButtonId) -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect())
        frame = CGRect(
            x: x,
            y: y,
            width: width,
            height: height
        )

        isHidden = true

        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center

        startButton.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)

        stackView.addArrangedSubview(startButton)
        stackView.setCustomSpacing(Dimensions.separator, after: startButton)
        stackView.addArrangedSubview(homeButton)
        stackView.setCustomSpacing(Dimensions.separator, after: homeButton)
        stackView.addArrangedSubview(stopButton)

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)
    }
}

// Public methods
extension CommandView {
    func setControls(for state: MissionState) {
        switch state {
            case .uploaded:
                startButton.id = .start
                stopButton.id = .stop
            case .paused:
                startButton.id = .resume
                stopButton.id = .stop
            case .running:
                startButton.id = .pause
                stopButton.id = .stop
            default:
                break
        }
    }

    func toggleShow(_ show: Bool) {
        self.layer.opacity = show ? 1 : 0
    }
}

// Handle control events
extension CommandView {
    @objc func onButtonPressed(_ sender: CommandButton) {
        if let id = sender.id {
            buttonPressed?(id)
        }
    }
}
