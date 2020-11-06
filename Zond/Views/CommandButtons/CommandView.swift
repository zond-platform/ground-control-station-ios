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
    private var stopButton = CommandButton(.stop)

    // Computed properties
    private var x: CGFloat {
        return -Dimensions.commandButtonDiameter
    }
    private var y: CGFloat {
        return Dimensions.screenHeight * CGFloat(0.5) - Dimensions.commandButtonDiameter - Dimensions.spacer * CGFloat(0.5)
    }
    private var width: CGFloat {
        return Dimensions.commandButtonDiameter
    }
    private var height: CGFloat {
        return Dimensions.commandButtonDiameter * CGFloat(2)
    }
    private var shouldOffset: Bool {
        Dimensions.isPhoneWithRoundedCorners && UIDevice.current.orientation == .landscapeLeft
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
        stackView.setCustomSpacing(Dimensions.spacer, after: startButton)
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
                stopButton.isEnabled = false
            case .paused:
                startButton.id = .resume
                stopButton.id = .stop
                stopButton.isEnabled = true
            case .running:
                startButton.id = .pause
                stopButton.id = .stop
                stopButton.isEnabled = true
            default:
                break
        }
    }

    func toggleShowFromSide(_ show: Bool) {
        let shownX = shouldOffset ? Dimensions.spacer + Dimensions.safeAreaOffset
                                  : Dimensions.spacer
        let notShownX = shouldOffset ? x + Dimensions.safeAreaOffset
                                     : x
        self.frame.origin.x = show ? shownX
                                   : notShownX
    }

    func adaptToDeviceOrientation() {
        toggleShowFromSide(!isHidden)
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
