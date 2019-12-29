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
    private var buttons: [ButtonName:SelectorButton] = [:]

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(frame: CGRect())
        for name in ButtonName.allCases {
            buttons[name] = SelectorButton(name)
            addSubview(buttons[name]!)
            buttons[name]!.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
            buttons[name]!.titleLabel?.font = UIFont(name: "Courier", size: 12)
            buttons[name]!.setTitle(String(describing: name), for: .normal)
            buttons[name]!.addTarget(self, action: #selector(onButtonPress(_:)), for: .touchDown)
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

        var hOffset: CGFloat = 0.0
        var vOffset: CGFloat = 0.0
        let hSize = 2
        let vSize = 4
        let buttonWidth = viewWidth / CGFloat(hSize)
        let buttonHeight = viewHeight / CGFloat(vSize)

        var buttonFrames: [CGRect] = []
        for _ in 0..<vSize {
            for _ in 0..<hSize {
                buttonFrames.append(CGRect(
                    x: hOffset,
                    y: vOffset,
                    width: buttonWidth,
                    height: buttonHeight
                ))
                hOffset += buttonWidth
            }
            hOffset = 0.0
            vOffset += buttonHeight
        }

        for button in ButtonName.allCases {
            if let buttonFrame = buttonFrames.first {
                buttons[button]!.frame = buttonFrame
                buttonFrames.removeFirst()
            }
        }
    }
}

// Public methods
extension ControlView {
    func onSimulatorResponse(_ success: Bool) {
        if !success {
            buttons[.simulator]!.setSelected(false)
        }
        buttons[.simulator]!.isUserInteractionEnabled = true
    }

    func onConnectionEstablished() {
        buttons[.restart]!.setSelected(false)
        buttons[.restart]!.isUserInteractionEnabled = true
    }

    @objc func onButtonPress(_ sender: SelectorButton) {
        sender.setSelected(!sender.isSelected)
        switch sender.name {
            case .simulator:
                // Forbid interaction until the simulator responds with a status
                sender.isUserInteractionEnabled = false
                delegate?.simulatorButtonSelected(sender.isSelected)
            case .restart:
                // Forbid interaction until the connection is re-established
                sender.isUserInteractionEnabled = false
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
