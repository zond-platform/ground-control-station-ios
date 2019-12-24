//
//  RootView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/25/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class RootView : UIView {
    private let navigationViewWidth: CGFloat = 50.0
    private let consoleViewWidthRate: CGFloat = 0.4
    private let statusViewHeight: CGFloat = 20.0
    
    private var mapView = UIView()
    private var navigationView = UIView()
    private var statusView = UIView()
    private var consoleView = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(_ env: Environment) {
        super.init(frame: CGRect())
        self.mapView.addSubview(env.mapViewController().view)
        self.navigationView.addSubview(env.navigationViewConroller().view)
        self.statusView.addSubview(env.statusViewController().view)
        self.consoleView.addSubview(env.consoleViewController().view)
        addSubview(self.mapView)
        addSubview(self.navigationView)
        addSubview(self.statusView)
        addSubview(self.consoleView)
        consoleView.isHidden = true
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
        mapView.frame = CGRect(
            x: 0,
            y: 0,
            width: screenWidth,
            height: screenHeight
        )
        navigationView.frame = CGRect(
            x: screenWidth - 2.0 * navigationViewWidth,
            y: 0.25 * screenHeight,
            width: 1.5 * navigationViewWidth,
            height: 0.5 * screenHeight
        )
        statusView.frame = CGRect(
            x: 0,
            y: 0,
            width: screenWidth,
            height: statusViewHeight
        )
        consoleView.frame = CGRect(
            x: 0,
            y: statusViewHeight,
            width: screenWidth * consoleViewWidthRate,
            height: screenHeight
        )
    }
}

extension RootView {
    func showConsoleView(_ show: Bool) {
        consoleView.isHidden = !show
    }
}
