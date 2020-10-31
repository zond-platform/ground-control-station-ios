//
//  MapView.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 4/27/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import MapKit

class MapView : MKMapView {
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
    }
}
