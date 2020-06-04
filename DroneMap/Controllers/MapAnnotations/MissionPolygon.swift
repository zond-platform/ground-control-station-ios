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
    func setGridDistance(_ distance: CGFloat)
    func translateMapPoint(_ mapPoint: MKMapPoint) -> CGPoint
    func translateRawPoint(_ rawPoint: CGPoint) -> MKMapPoint
}

class MissionPolygon : MKPolygon {
    // Stored properties
    private var verticies: [CGPoint] = []
    private var vertexOffsets: [CGPoint] = []
    private var missionGrid: [CGPoint] = []
    private var draggedVertexId: Int?
    var vertexArea = MissionRenderer.vertexRadius

    // Observer properties
    weak var delegate: MissionPolygonDelegate? {
        didSet {
            verticies.removeAll(keepingCapacity: true)
            for id in 0..<pointCount {
                verticies.append(delegate!.translateMapPoint(points()[id]))
            }
            delegate!.redrawRenderer()
        }
    }
    var gridDistance: CGFloat = 20.0 {
        didSet {
            if delegate != nil {
                delegate!.setGridDistance(gridDistance)
            }
        }
    }

    convenience init(_ coordinates: [CLLocationCoordinate2D]) {
        self.init(coordinates: coordinates, count: coordinates.count)
    }
}

// Public methods
extension MissionPolygon {
    func convexHull() -> ConvexHull {
        return DroneMap.convexHull(verticies)
    }

    func missionGrid(for hull: ConvexHull, with delta: CGFloat) -> [CGPoint] {
        missionGrid = DroneMap.missionGrid(hull, delta)
        return missionGrid
    }
    
    func missionCoordinates() -> [CLLocationCoordinate2D] {
        if delegate != nil {
            var coordinates: [CLLocationCoordinate2D] = []
            for point in missionGrid {
                coordinates.append(delegate!.translateRawPoint(point).coordinate)
            }
            return coordinates
        } else {
            return []
        }
    }

    func bodyContainsCoordinate(_ coordinate: CLLocationCoordinate2D) -> Bool {
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

    func vertexContainsCoordinate(_ coordinate: CLLocationCoordinate2D) -> Bool {
        if delegate != nil {
            for id in 0..<pointCount {
                let vertexPosition = delegate!.translateMapPoint(points()[id])
                let touchPosition = delegate!.translateMapPoint(MKMapPoint(coordinate))
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

    func verticalDistance() -> CGFloat {
        let low = delegate!.translateRawPoint(lowermost(verticies))
        let up = delegate!.translateRawPoint(uppermost(verticies))
        return CGFloat(low.distance(to: up))
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
        delegate?.redrawRenderer()
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
        if delegate != nil {
            points()[id] = MKMapPoint(coordinate)
            verticies[id] = delegate!.translateMapPoint(points()[id])
            if redraw {
                delegate!.redrawRenderer()
            }
        }
    }
}
