//
//  MapView.swift
//  Aeroglaz
//
//  Created by Evgeny Agamirzov on 4/27/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import MapKit

class MapView : MKMapView {
    private var appleLogo: UIView!
    private var legalLabel: UIView!

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
        mapType = .satellite
        showsCompass = false
        appleLogo = subviews[1]
        legalLabel = subviews[2]
    }
}

// Public methods
extension MapView {
    func repositionLegalLabels() {
        appleLogo.frame = CGRect(
            x: Dimensions.ContentView.x,
            y: ConsoleView.yOffset - appleLogo.frame.size.height,
            width: appleLogo.frame.size.width,
            height: appleLogo.frame.size.height
        )
        legalLabel.frame = CGRect(
            x: Dimensions.ContentView.x + Dimensions.ContentView.width - legalLabel.frame.size.width,
            y: ConsoleView.yOffset - legalLabel.frame.size.height,
            width: legalLabel.frame.size.width,
            height: legalLabel.frame.size.height
        )
    }
}
