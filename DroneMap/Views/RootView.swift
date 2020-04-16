//
//  RootView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/25/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class RootView : UIView {
    private var mapView = UIView()
    private var settingsView = UIView()
    private var buttonsView = UIView()
    
    private let settingsViewWidthRate = CGFloat(0.4)
    private let settingsViewMarginRate = CGFloat(0.01)
    private let buttonsViewWidthRate = CGFloat(0.1)

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(_ env: Environment) {
        super.init(frame: CGRect())
        self.mapView.addSubview(env.mapViewController().view)
        self.buttonsView.addSubview(env.buttonsViewController().view)
        self.settingsView.layer.masksToBounds = false
        self.settingsView.layer.shadowColor = UIColor.black.cgColor
        self.settingsView.layer.shadowOpacity = 0.6
        self.settingsView.layer.shadowOffset = .zero
        self.settingsView.layer.shadowRadius = 4
        self.settingsView.layer.shouldRasterize = true
        self.settingsView.layer.rasterizationScale = UIScreen.main.scale
        self.settingsView.addSubview(env.consoleViewController().view)
        addSubview(self.mapView)
        addSubview(self.settingsView)
        addSubview(self.buttonsView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        frame = CGRect(
            x: 0,
            y: 0,
            width: screenWidth,
            height: screenHeight
        )
        mapView.frame = frame
        settingsView.frame = CGRect(
            x: screenWidth * settingsViewMarginRate,
            y: screenWidth * settingsViewMarginRate,
            width: screenWidth * settingsViewWidthRate,
            height: screenHeight - screenWidth * settingsViewMarginRate
        )
        buttonsView.frame = CGRect(
            x: screenWidth - screenWidth * buttonsViewWidthRate,
            y: 0,
            width: screenWidth * buttonsViewWidthRate,
            height: screenHeight
        )
    }
}
