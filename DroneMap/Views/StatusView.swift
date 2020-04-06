//
//  StatusView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 20.12.19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class StatusView : UIView {
    private var labels: [StatusLabel] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(frame: CGRect())
        backgroundColor = UIColor(white: 0.1, alpha: 0.6)
        for type in StatusValueName.allCases {
            labels.append(StatusLabel(type))
            self.addSubview(labels.last!)
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
        alignViews(&labels,
                   withLayout: .grid,
                   within: frame)
    }
}

// Public methods
extension StatusView {
    func updateValue(_ name: StatusValueName, _ value: String) {
        statusLabel(withName: name)!.setValue(value)
    }
}

// Private methods
extension StatusView {
    private func statusLabel(withName labelName: StatusValueName) -> StatusLabel? {
        for label in labels {
            if label.type == labelName {
                return label;
            }
        }
        return nil
    }
}
