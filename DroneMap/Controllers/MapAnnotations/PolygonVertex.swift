//
//  PolygonVertex.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 24.12.19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit
import MapKit

protocol PolygonVertexDelegate : AnyObject {
    func vertexCoordinateUpdated(_ newCoordinate: CLLocationCoordinate2D, _ id: Int)
}

class PolygonVertex : MKPointAnnotation {
    weak var delegate: PolygonVertexDelegate?
    public let id: Int
    private var dLat: Double = 0.0
    private var dLon: Double = 0.0
    override var coordinate: CLLocationCoordinate2D {
        didSet {
            delegate?.vertexCoordinateUpdated(coordinate, id)
        }
    }

    init(_ coordinate: CLLocationCoordinate2D, _ id: Int) {
        self.id = id
        super.init()
        self.coordinate = coordinate
    }
}

// Public methods
extension PolygonVertex {
    func compute(displacementTo coordinate: CLLocationCoordinate2D) {
        dLat = self.coordinate.latitude - coordinate.latitude
        dLon = self.coordinate.longitude - coordinate.longitude
    }

    func move(relativeTo coordinate: CLLocationCoordinate2D) {
        self.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude + dLat,
                                                 longitude: coordinate.longitude + dLon)
    }
}
