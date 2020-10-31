//
//  RootView.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 4/25/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class RootView : UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect(
            x: 0,
            y: 0,
            width: Dimensions.screenWidth,
            height: Dimensions.screenHeight
        ))

        addSubview(Environment.mapViewController.view)
        addSubview(Environment.statusViewController.view)
        addSubview(Environment.commandViewController.view)
        addSubview(Environment.missionViewController.view)
        addSubview(Environment.dynamicTelemetryViewController.view)
        addSubview(Environment.locatorViewController.view)
    }
}
