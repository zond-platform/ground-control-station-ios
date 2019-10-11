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
    private var consoleView = ConsoleView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(_ mapView: UIView,
         _ navigationView: UIView,
         _ statusView: UIView,
         _ logView: UIView) {
        
        super.init(frame: CGRect())
        
        // Build view hirarchy
        self.mapView.addSubview(mapView)
        self.navigationView.addSubview(navigationView)
        self.consoleView.addSubviews(statusView, logView)
        addSubview(self.mapView)
        addSubview(self.navigationView)
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
        consoleView.frame = CGRect(
            x: 0,
            y: 0,
            width: screenWidth * 0.6,
            height: screenHeight
        )
    }
    
    func showConsoleView(_ show: Bool) {
        consoleView.isHidden = !show
    }
}
