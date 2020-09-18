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
        addSubview(Environment.consoleViewController.view)
        addSubview(Environment.missionViewController.view)
        addSubview(Environment.navigationViewController.view)
        addSubview(Environment.statusViewController.view)
    }
}
