//
//  MapView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/27/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import MapKit

class MapView : MKMapView {
    private var legalLabel: UIView!
    private var legalLabelMinX: CGFloat = 0.0

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
        legalLabel = subviews[2]
        legalLabelMinX = legalLabel.frame.minX
    }
}

// Public methods
extension MapView {
    func moveLegalLabel() {
        legalLabel.frame = CGRect(
            x: legalLabelMinX - NavigationView.width,
            y: legalLabel.frame.minY,
            width: legalLabel.frame.size.width,
            height: legalLabel.frame.size.height
        )
    }
}
