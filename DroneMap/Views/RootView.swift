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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(_ env: Environment) {
        super.init(frame: CGRect())
        self.mapView.addSubview(env.mapViewController().view)
        self.selectorView.addSubview(env.selectorViewConroller().view)
        addSubview(self.mapView)
        addSubview(self.selectorView)
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
        selectorView.frame = CGRect(
            x: 0,
            y: 0,
            width: screenWidth * 0.4,
            height: screenHeight
        )
    }
}
