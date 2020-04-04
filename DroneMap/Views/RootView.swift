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
    private var selectorView = UIView()
    private var controlView = UIView()
    private var statusView = UIView()
    private var consoleView = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(_ env: Environment) {
        super.init(frame: CGRect())
        self.mapView.addSubview(env.mapViewController().view)
        self.selectorView.addSubview(env.selectorViewConroller().view)
        self.controlView.addSubview(env.navigationViewConroller().view)
        self.statusView.addSubview(env.statusViewController().view)
        self.consoleView.addSubview(env.consoleViewController().view)
        addSubview(self.mapView)
        addSubview(self.selectorView)
        addSubview(self.controlView)
        addSubview(self.statusView)
        addSubview(self.consoleView)
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
        var views = [selectorView, statusView, consoleView, controlView]
        let ratios: [CGFloat] = [0.1, 0.2, 0.3, 0.4]
        alignViews(&views,
                   withLayout: .vertical,
                   within: CGSize(width: screenWidth * 0.4, height: screenHeight),
                   using: ratios)
    }
}
