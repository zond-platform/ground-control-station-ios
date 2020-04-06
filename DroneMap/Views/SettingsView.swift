//
//  SettingsView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 5/25/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class SettingsView : UITableView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(frame: CGRect(), style: .grouped)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        frame = CGRect(
            x: 0,
            y: 0,
            width: superview?.frame.width ?? 0,
            height: superview?.frame.height ?? 0
        )
    }
}
