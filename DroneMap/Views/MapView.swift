//
//  MapView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/27/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import MapKit

class MapView : MKMapView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        // Default initialize with dummy non-zero values for width
        // and height to silence auto layout warnings (allegedly a bug).
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        mapType = .satellite
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        frame = CGRect(
            x: 0,
            y: 0,
            width: superview?.frame.width ?? 0,
            height: superview?.frame.height ?? 0
        )
    }
}
