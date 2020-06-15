//
//  MissionRenderer.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 24.12.19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit
import MapKit

class MissionPolygon : MKPolygon {
    // Stored properties
    var vertexArea = MissionRenderer.vertexRadius
    var verticies: [CGPoint] = []
    private var vertexOffsets: [CGPoint] = []
    private var missionGrid: [CGPoint] = []
    private var draggedVertexId: Int?

    // Observer properties
    weak var renderer: MissionRenderer? {
        didSet {
            for id in 0..<pointCount {
                verticies.append(renderer!.point(for: points()[id]))
            }
        }
    }
    var gridDistance: CGFloat? {
        didSet {
            renderer?.redrawRenderer()
        }
    }
    var missionState: MissionState? {
        didSet {
            renderer?.missionState = missionState
        }
    }
    var aircraftLocation: CLLocation? {
        didSet {
            renderer?.redrawRenderer()
        }
    }

    convenience init(_ coordinates: [CLLocationCoordinate2D]) {
        self.init(coordinates: coordinates, count: coordinates.count)
    }
}

// Public methods
extension MissionPolygon {
    func convexHull() -> ConvexHull {
        return AeroGlaz.convexHull(verticies)
    }

    func missionGrid(for hull: ConvexHull, with delta: CGFloat) -> [CGPoint] {
        missionGrid = AeroGlaz.missionGrid(hull, delta)
        return missionGrid
    }
    
    func missionCoordinates() -> [CLLocationCoordinate2D] {
        if renderer != nil {
            var coordinates: [CLLocationCoordinate2D] = []
            for point in missionGrid {
                coordinates.append(renderer!.mapPoint(for: point).coordinate)
            }
            return coordinates
        } else {
            return []
        }
    }

    func bodyContainsCoordinate(_ coordinate: CLLocationCoordinate2D) -> Bool {
        if renderer != nil {
            let left = leftmost(verticies)
            let right = rightmost(verticies)
            let low = lowermost(verticies)
            let up = uppermost(verticies)

            let origin = CGPoint(x: left.x, y: low.y)
            let width = Double(right.x) - Double(left.x)
            let height = Double(up.y) - Double(low.y)

            let polygonOrigin = renderer!.mapPoint(for: origin)
            let polygonSize = MKMapSize(width: width, height: height)
            let polygonRect = MKMapRect(origin: polygonOrigin, size: polygonSize)
            
            return polygonRect.contains(MKMapPoint(coordinate))
        } else {
            return false
        }
    }

    func vertexContainsCoordinate(_ coordinate: CLLocationCoordinate2D) -> Bool {
        if renderer != nil {
            for id in 0..<pointCount {
                let vertexPosition = renderer!.point(for: points()[id])
                let touchPosition = renderer!.point(for: MKMapPoint(coordinate))
                let distance = norm(Vector(vertexPosition, touchPosition))
                if distance < vertexArea {
                    draggedVertexId = id
                    return true
                }
            }
            draggedVertexId = nil
            return false
        } else {
            draggedVertexId = nil
            return false
        }
    }

    func computeCenter() -> CLLocationCoordinate2D {
        var lat = CLLocationDegrees()
        var lon = CLLocationDegrees()
        for id in 0..<pointCount {
            lat += points()[id].coordinate.latitude
            lon += points()[id].coordinate.longitude
        }
        return CLLocationCoordinate2D(latitude: lat / Double(pointCount),
                                      longitude: lon / Double(pointCount))
    }

    func computeVertexOffsets(relativeTo coordinate: CLLocationCoordinate2D) {
        vertexOffsets.removeAll(keepingCapacity: true)
        for id in 0..<pointCount {
            let dLat = points()[id].coordinate.latitude - coordinate.latitude
            let dLon = points()[id].coordinate.longitude - coordinate.longitude
            vertexOffsets.append(CGPoint(x: dLat, y: dLon))
        }
    }

    func movePolygon(to coordinate: CLLocationCoordinate2D) {
        for id in 0..<vertexOffsets.count {
            let lat = coordinate.latitude + CLLocationDegrees(vertexOffsets[id].x)
            let lon = coordinate.longitude + CLLocationDegrees(vertexOffsets[id].y)
            updateVertex(CLLocationCoordinate2D(latitude: lat, longitude: lon), id: id, redraw: false)
        }
        // Redraw manually only after all points are updated
        renderer?.redrawRenderer()
    }

    func moveVertex(to coordinate: CLLocationCoordinate2D) {
        if draggedVertexId != nil && vertexOffsets.count >= draggedVertexId! {
            let lat = coordinate.latitude + CLLocationDegrees(vertexOffsets[draggedVertexId!].x)
            let lon = coordinate.longitude + CLLocationDegrees(vertexOffsets[draggedVertexId!].y)
            updateVertex(CLLocationCoordinate2D(latitude: lat, longitude: lon), id: draggedVertexId!, redraw: true)
        }
    }
}

// Private methods
extension MissionPolygon {
    private func updateVertex(_ coordinate: CLLocationCoordinate2D, id: Int, redraw: Bool) {
        if renderer != nil {
            points()[id] = MKMapPoint(coordinate)
            verticies[id] = renderer!.point(for: points()[id])
            if redraw {
                renderer!.redrawRenderer()
            }
        }
    }
}
