//
//  StatusView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 20.12.19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum StatusValueType {
    case mode
    case gps
    case satellites
    case battery
    case altitude
}

extension StatusValueType : CaseIterable {}

class StatusLabel : UIView {
    private let widthRate = CGFloat(0.6)
    
    private var type = UILabel()
    private var value = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(_ type: StatusValueType) {
        super.init(frame: CGRect())
        var valueDescription: String
        switch type {
            case .gps:
                valueDescription = "GPS"
            case .battery:
                valueDescription = "BAT"
            case .satellites:
                valueDescription = "SAT"
            case .altitude:
                valueDescription = "ALT"
            case .mode:
                valueDescription = "MOD"
        }
        self.type.text = valueDescription
        self.type.textColor = UIColor.white
        self.type.font = UIFont(name: "Courier", size: 12)!
        self.type.backgroundColor = UIColor.clear
        self.value.text = "-"
        self.value.textColor = UIColor.white
        self.value.font = UIFont(name: "Courier", size: 12)!
        self.value.backgroundColor = UIColor.clear
        addSubview(self.type)
        addSubview(self.value)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let typeLabelWidth = (1 - widthRate) * frame.width
        let valueLabelWidth = widthRate * frame.width
        self.type.frame = CGRect(
            x: 0,
            y: 0,
            width: typeLabelWidth,
            height: frame.height
        )
        self.value.frame = CGRect(
            x: typeLabelWidth,
            y: 0,
            width: valueLabelWidth,
            height: frame.height
        )
    }
}

// Public functions
extension StatusLabel {
    func setValue(_ value: String) {
        self.value.text = value
    }
}

class StatusView : UIView {
    private var labels: [StatusValueType:StatusLabel] = [:]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(frame: CGRect())
        backgroundColor = UIColor(white: 0.1, alpha: 0.6)
        for type in StatusValueType.allCases {
            labels[type] = StatusLabel(type)
            self.addSubview(labels[type]!)
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
        
        // Layout labels
        let numLabels = CGFloat(StatusValueType.allCases.count)
        let labelWidth = 0.75 * viewWidth / numLabels
        let spacerWidth = (viewWidth - numLabels * labelWidth) / (numLabels + 1)
        var offset = spacerWidth
        for type in StatusValueType.allCases {
            labels[type]!.frame = CGRect(
                x: offset,
                y: 0,
                width: labelWidth,
                height: viewHeight
            )
            offset += (labelWidth + spacerWidth)
        }
    }
}

// Public functions
extension StatusView {
    func updateValue(_ type: StatusValueType, _ value: String) {
        if let label = labels[type] {
            label.setValue(value)
        }
    }
}
