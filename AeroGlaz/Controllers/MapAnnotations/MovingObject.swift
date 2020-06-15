//
//  MovingObject.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 24.12.19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit
import MapKit

enum MovingObjectType {
    case aircraft
    case home
    case user
}

class MovingObject : MKPointAnnotation {
    // Stored properties
    var type: MovingObjectType
    var isTracked = false
    var coordinateChanged: ((_ coordinate: CLLocationCoordinate2D) -> Void)?
    var headingChanged: ((_ coordinate: CLLocationDirection) -> Void)?

    // Observer properties
    var heading: CLLocationDirection {
        didSet {
            headingChanged?(heading)
        }
    }
    override var coordinate: CLLocationCoordinate2D {
        didSet {
            coordinateChanged?(coordinate)
        }
    }

    init(_ coordinate: CLLocationCoordinate2D, _ heading: CLLocationDirection, _ type: MovingObjectType) {
        self.type = type
        self.heading = heading
        super.init()
        self.coordinate = coordinate
    }
}
