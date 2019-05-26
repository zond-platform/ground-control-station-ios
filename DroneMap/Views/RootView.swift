//
//  RootView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/25/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

/*************************************************************************************************/
class RootView : UIView {
    private let navigationViewWidth: CGFloat = 50.0
    private var mapView = UIView()
    private var navigationView = UIView()
    private var tabView = TabView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(_ mapView: UIView,
         _ navigationView: UIView,
         _ statusView: UIView,
         _ consoleView: UIView) {
        
        super.init(frame: CGRect())
        
        self.mapView.addSubview(mapView)
        self.navigationView.addSubview(navigationView)
        self.tabView.addSubviews(statusView, consoleView)
        
        addSubview(self.mapView)
        addSubview(self.navigationView)
        addSubview(self.tabView)
        
        setStyle()
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
        tabView.frame = CGRect(
            x: 0,
            y: 0,
            width: screenWidth * 0.4,
            height: screenHeight
        )
    }
    
    func setStyle() {
        tabView.isHidden = true
    }
    
    func showTabView(_ show: Bool) {
        tabView.isHidden = !show
    }
}
