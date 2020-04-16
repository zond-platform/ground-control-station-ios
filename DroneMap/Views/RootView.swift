//
//  RootView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/25/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class RootView : UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(_ env: Environment) {
        super.init(frame: CGRect(
            x: 0,
            y: 0,
            width: AppDimensions.screenWidth,
            height: AppDimensions.screenHeight
        ))

        addSubview(env.mapViewController().view)
        addSubview(env.settingsViewController().view)
        addSubview(env.buttonsViewController().view)
    }
}
