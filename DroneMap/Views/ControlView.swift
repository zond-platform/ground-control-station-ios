//
//  ControlView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 5/3/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

protocol ControlViewDelegate : AnyObject {
    func simulatorButtonSelected(_ selected: Bool)
    func restartButtonPressed()
    func missionEditingMode(_ enable: Bool)
    func uploadButtonPressed()
    func startButtonPressed()
    func stopButtonPressed()
    func pauseButtonPressed()
    func resumeButtonPressed()
}

class ControlView : UIView {
    weak var delegate: ControlViewDelegate?
    private var buttons: [ControlButton] = []

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(frame: CGRect())
        for name in ControlButtonName.allCases {
            buttons.append(ControlButton(name))
            addSubview(buttons.last!)
            buttons.last!.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
            buttons.last!.titleLabel?.font = UIFont(name: "Courier", size: 12)
            buttons.last!.setTitle(String(describing: name), for: .normal)
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
                   withLayout: .grid,
                   within: CGSize(width: viewWidth, height: viewHeight))
    }
}

// Public methods
extension ControlView {
    func onSimulatorResponse(_ success: Bool) {
        if !success {
            controlButton(withName: .simulator)!.setSelected(false)
        }
        controlButton(withName: .simulator)!.isEnabled = true
    }

    func onConnectionEstablished() {
        controlButton(withName: .restart)!.setSelected(false)
        controlButton(withName: .restart)!.isEnabled = true
    }

    @objc func onButtonPress(_ sender: ControlButton) {
        sender.setSelected(!sender.isSelected)
        switch sender.name {
            case .simulator:
                // Forbid interaction until the simulator responds with a status
                sender.isEnabled = false
                delegate?.simulatorButtonSelected(sender.isSelected)
            case .restart:
                // Forbid interaction until the connection is re-established
                sender.isEnabled = false
                delegate?.restartButtonPressed()
            case .mission:
                delegate?.missionEditingMode(sender.isSelected)
            case .upload:
                sender.setSelected(false)
                delegate?.uploadButtonPressed()
            case .start:
                sender.setSelected(false)
                delegate?.startButtonPressed()
            case .stop:
                sender.setSelected(false)
                delegate?.stopButtonPressed()
            case .pause:
                sender.setSelected(false)
                delegate?.pauseButtonPressed()
            case .resume:
                sender.setSelected(false)
                delegate?.resumeButtonPressed()
            default:
                return
        }
    }
}

// Private methods
extension ControlView {
    private func controlButton(withName buttonName: ControlButtonName) -> ControlButton? {
        for button in buttons {
            if button.name == buttonName {
                return button;
            }
        }
        return nil
    }
}
