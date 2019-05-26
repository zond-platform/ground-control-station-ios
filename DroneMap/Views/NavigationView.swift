//
//  NavigationView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 5/3/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum ButtonName {
    case console
    case simulator
    case restart
    case takeoff
    case land
}

extension ButtonName : CaseIterable {}

protocol NavigationViewDelegate : AnyObject {
    func restartButtonPressed()
    func consoleButtonSelected(_ selected: Bool)
    func simulatorButtonSelected(_ selected: Bool)
    func takeOffRequested()
    func landingRequested()
}

/*************************************************************************************************/
class SelectorButton : UIButton {
    var name: ButtonName?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(_ name: ButtonName) {
        self.name = name
        super.init(frame: CGRect())
    }
    
    func setSelected(_ selected: Bool) {
        isSelected = selected
        backgroundColor = isSelected ? UIColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 0.8)
                                     : UIColor(white: 0.0, alpha: 0.6)
    }
    
    func setHighlighted(_ highlighted: Bool) {
        isHighlighted = highlighted
        backgroundColor = isHighlighted ? UIColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 0.8)
                                        : UIColor(white: 0.0, alpha: 0.6)
    }
}

/*************************************************************************************************/
class NavigationView : UIView {
    weak var delegate: NavigationViewDelegate?
    private let annotationView = UIView()
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
            buttons[name]!.addTarget(self, action: #selector(onButtonPress(_:)), for: name == .takeoff || name == .land
                                                                                      ? .touchDownRepeat
                                                                                      : .touchDown)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let viewWidth = superview!.frame.width
        let viewHeight = superview!.frame.height
        frame = CGRect(
            x: 0,
            y: 0,
            width: viewWidth,
            height: viewHeight
        )
        
        // Layout buttons
        var offset: CGFloat = 0.0
        let numButtons: CGFloat = CGFloat(ButtonName.allCases.count)
        for button in ButtonName.allCases {
            let buttonHeight = 0.75 * viewHeight / numButtons
            let spacerHeight = (viewHeight - numButtons * buttonHeight) / (numButtons - 1)
            buttons[button]!.frame = CGRect(
                x: 0,
                y: offset,
                width: viewWidth,
                height: buttonHeight
            )
            offset += (buttonHeight + spacerHeight)
        }
    }
}

/*************************************************************************************************/
extension NavigationView {
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
        switch sender.name! {
            case .restart:
                // Forbid interaction until the connection is re-established
                sender.isUserInteractionEnabled = false
                delegate?.restartButtonPressed()
            case .console:
                delegate?.consoleButtonSelected(sender.isSelected)
            case .simulator:
                // Forbid interaction until the simulator responds with a status
                sender.isUserInteractionEnabled = false
                delegate?.simulatorButtonSelected(sender.isSelected)
            case .takeoff:
                sender.setSelected(false)
                delegate?.takeOffRequested()
            case .land:
                sender.setSelected(false)
                delegate?.landingRequested()
        }
    }
}
