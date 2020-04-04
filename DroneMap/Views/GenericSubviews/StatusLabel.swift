//
//  StatusLabel.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 26.12.19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum StatusValueName {
    case product
    case mode
    case gps
    case satellites
    case battery
    case altitude
}

extension StatusValueName : CaseIterable {}

class StatusLabel : UIView {
    private let widthRate = CGFloat(0.6)
    private var typeLabel = UILabel()
    private var valueLabel = UILabel()

    var type: StatusValueName!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(_ type: StatusValueName) {
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
        self.type = type
        self.typeLabel.text = valueDescription
        self.typeLabel.textColor = UIColor.white
        self.typeLabel.font = UIFont(name: "Courier", size: 12)!
        self.typeLabel.backgroundColor = UIColor.clear
        self.valueLabel.text = "-"
        self.valueLabel.textColor = UIColor.white
        self.valueLabel.font = UIFont(name: "Courier", size: 12)!
        self.valueLabel.backgroundColor = UIColor.clear
        addSubview(self.typeLabel)
        addSubview(self.valueLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let typeLabelWidth = (1 - widthRate) * frame.width
        let valueLabelWidth = widthRate * frame.width
        self.typeLabel.frame = CGRect(
            x: 0,
            y: 0,
            width: typeLabelWidth,
            height: frame.height
        )
        self.valueLabel.frame = CGRect(
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
        self.valueLabel.text = value
    }
}
