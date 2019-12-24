//
//  MissionRenderer.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 24.12.19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit
import MapKit

protocol MissionPolygonDelegate : AnyObject {
    func redrawRenderer()
    func translateMapPoint(_ mapPoint: MKMapPoint) -> CGPoint
    func translateRawPoint(_ rawPoint: CGPoint) -> MKMapPoint
}

class MissionPolygon : MKPolygon {
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
}

// Public functions
extension MissionPolygon {
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

// Private functions
extension MissionPolygon {
    private func updateVertex(_ newCoordinate: CLLocationCoordinate2D, _ id: Int) {
        if delegate != nil {
            points()[id] = MKMapPoint(newCoordinate)
            verticies[id] = delegate!.translateMapPoint(points()[id])
            delegate!.redrawRenderer()
        }
    }
}

// Track vertex drag
extension MissionPolygon : PolygonVertexViewDelegate {
    func vertexViewDragged(_ newPosition: CGPoint, _ id: Int) {
        updateVertex(mapView.convert(newPosition, toCoordinateFrom: mapView), id)
    }
}

// Track vertex coordinate update
extension MissionPolygon : PolygonVertexDelegate {
    func vertexCoordinateUpdated(_ newCoordinate: CLLocationCoordinate2D, _ id: Int) {
        updateVertex(newCoordinate, id)
    }
}
