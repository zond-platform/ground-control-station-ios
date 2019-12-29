//
//  StatusView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 20.12.19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

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

// Public methods
extension StatusView {
    func updateValue(_ type: StatusValueType, _ value: String) {
        if let label = labels[type] {
            label.setValue(value)
        }
    }
}
