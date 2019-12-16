//
//  MapObjects.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 16.12.19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit
import MapKit

protocol MovingObjectDelegate : AnyObject {
    func objectHeadingChanged(_ heading: CLLocationDirection)
}

protocol PolygonVertexDelegate : AnyObject {
    func vertexCoordinateUpdated(_ newCoordinate: CLLocationCoordinate2D, _ id: Int)
}

protocol MissionPolygonDelegate : AnyObject {
    func redrawRenderer()
    func translateMapPoint(_ mapPoint: MKMapPoint) -> CGPoint
    func translateRawPoint(_ rawPoint: CGPoint) -> MKMapPoint
}

class MovingObject : MKPointAnnotation {
    weak var delegate: MovingObjectDelegate?
    var type: MovingObjectType
    var heading: CLLocationDirection {
        didSet {
            delegate?.objectHeadingChanged(heading)
        }
    }

    init(_ coordinate: CLLocationCoordinate2D, _ heading: CLLocationDirection, _ type: MovingObjectType) {
        self.type = type
        self.heading = heading
        super.init()
        self.coordinate = coordinate
    }
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

    func compute(displacementTo coordinate: CLLocationCoordinate2D) {
        dLat = self.coordinate.latitude - coordinate.latitude
        dLon = self.coordinate.longitude - coordinate.longitude
    }

    func move(relativeTo coordinate: CLLocationCoordinate2D) {
        self.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude + dLat,
                                                 longitude: coordinate.longitude + dLon)
    }
}

class MissionPolygon : MKPolygon, PolygonVertexDelegate, PolygonVertexViewDelegate {
    private weak var mapView: MKMapView!
    var verticies: [CGPoint] = []
    weak var delegate: MissionPolygonDelegate? {
        didSet {
            verticies.removeAll(keepingCapacity: true)
            for id in 0..<pointCount {
                verticies.append(delegate!.translateMapPoint(points()[id]))
            }
            delegate!.redrawRenderer()
        }
    }

    convenience init(_ coordinates: [CLLocationCoordinate2D], _ mapView: MKMapView) {
        self.init(coordinates: coordinates, count: coordinates.count)
        self.mapView = mapView
    }

    private func updateVertex(_ newCoordinate: CLLocationCoordinate2D, _ id: Int) {
        if delegate != nil {
            points()[id] = MKMapPoint(newCoordinate)
            verticies[id] = delegate!.translateMapPoint(points()[id])
            delegate!.redrawRenderer()
        }
    }

    func vertexCoordinateUpdated(_ newCoordinate: CLLocationCoordinate2D, _ id: Int) {
        updateVertex(newCoordinate, id)
    }

    func vertexViewDragged(_ newPosition: CGPoint, _ id: Int) {
        updateVertex(mapView.convert(newPosition, toCoordinateFrom: mapView), id)
    }

    func convexHull() -> ConvexHull {
        return DroneMap.convexHull(verticies)
    }

    func missionGrid(for hull: ConvexHull, with delta: CGFloat) -> [CGPoint] {
        return DroneMap.missionGrid(hull, delta)
    }

    func containsCoordinate(_ coordinate: CLLocationCoordinate2D) -> Bool {
        if delegate != nil {
            let left = leftmost(verticies)
            let right = rightmost(verticies)
            let low = lowermost(verticies)
            let up = uppermost(verticies)
            
            let origin = CGPoint(x: left.x, y: low.y)
            let width = Double(right.x) - Double(left.x)
            let height = Double(up.y) - Double(low.y)
            
            let polygonOrigin = delegate!.translateRawPoint(origin)
            let polygonSize = MKMapSize(width: width, height: height)
            let polygonRect = MKMapRect(origin: polygonOrigin, size: polygonSize)
            
            return polygonRect.contains(MKMapPoint(coordinate))
        } else {
            return false
        }
    }
}
