//
//  SelectorView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 05.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class SelectorItemView : UIView {
    var name: SelectorItemName!
    var views: [UIView] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(_ name: SelectorItemName) {
        super.init(frame: CGRect())
        self.name = name
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        alignViews(&views,
                   withLayout: .vertical,
                   within: CGRect(
                       x: 0,
                       y: 0,
                       width: frame.width,
                       height: frame.height
                   ))
    }
}

// Public methods
extension SelectorItemView {
    func assignViews(_ views: [UIView]) {
        self.views = views
        for view in views {
            addSubview(view)
        }
    }
}
