//
//  StatusLabel.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 26.12.19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum StatusValueType {
    case product
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
            case .product:
                valueDescription = "PRD"
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

// Public methods
extension StatusLabel {
    func setValue(_ value: String) {
        self.value.text = value
    }
}
