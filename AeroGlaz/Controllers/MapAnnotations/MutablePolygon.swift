//
//  MutablePolygon.swift
//  AeroGlaz
//
//  Created by Evgeny Agamirzov on 06.07.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import os.log

import UIKit
import MapKit

fileprivate let maxVertexCount: Int = 20
fileprivate let vertexRadius: CLLocationDistance = 50

class MutablePolygon : MKPolygon {
    // Stored properties
    var coordinates: [CLLocationCoordinate2D] = []
    private var offsets: [CGPoint] = []
    var dragIndex: Int?

    // Computed properties
    override var pointCount: Int {
        coordinates.count
    }
    var center: CLLocationCoordinate2D? {
        if pointCount > 0 {
            let lat = coordinates.reduce(0, { $0 + $1.latitude }) / CLLocationDegrees(pointCount)
            let lon = coordinates.reduce(0, { $0 + $1.longitude }) / CLLocationDegrees(pointCount)
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        } else {
            os_log("Cannot compute center. No vertices.", type: .debug)
            return nil
        }
    }

    convenience init?(_ coordinates: [CLLocationCoordinate2D]) {
        let staticCoordinates = Array(repeating: CLLocationCoordinate2D(), count: maxVertexCount)
        self.init(coordinates: staticCoordinates, count: maxVertexCount)
        self.coordinates = coordinates
        if pointCount <= maxVertexCount {
            syncCoordinates()
        } else {
            return nil
        }
    }
}

// Private methods
extension MutablePolygon {
    private func syncCoordinates() {
        for i in 0..<pointCount {
            points()[i] = MKMapPoint(coordinates[i])
        }
        for i in pointCount..<maxVertexCount {
            points()[i] = MKMapPoint()
        }
    }
}

// Public methods
extension MutablePolygon {
    func appendVetrex(with coordinate: CLLocationCoordinate2D) {
        if pointCount + 1 <= maxVertexCount {
            coordinates.append(coordinate)
            points()[pointCount] = MKMapPoint(coordinate)
        } else {
            os_log("Cannot add vertex. Maximum vertex count reached.", type: .debug)
        }
    }
    
    func updateVertex(at i: Int, with coordinate: CLLocationCoordinate2D) {
        if !coordinates.isEmpty && i >= 0 && i < pointCount {
            coordinates[i] = coordinate
            points()[i] = MKMapPoint(coordinate)
        } else {
            os_log("Cannot remove vertex. Invalid index.", type: .debug)
        }
    }

    func removeVetrex(at i: Int) {
        if !coordinates.isEmpty && i >= 0 && i < pointCount {
            coordinates.remove(at: i)
            syncCoordinates()
            if coordinates.isEmpty {
                dragIndex = nil
            }
        } else {
            os_log("Cannot remove vertex. Invalid index.", type: .debug)
        }
    }

    func replaceAllVertices(with coordinates: [CLLocationCoordinate2D]) {
        if pointCount <= maxVertexCount {
            self.coordinates = coordinates
            syncCoordinates()
        } else {
            os_log("Cannot replace vertices. Maximum vertex count exceeded.", type: .debug)
        }
    }

    func bodyContains(coordinate: CLLocationCoordinate2D) -> Bool {
        if pointCount > 0 {
            let minLat = coordinates.min{ $0.latitude < $1.latitude }!.latitude
            let minLon = coordinates.min{ $0.longitude < $1.longitude }!.longitude
            let dLat = coordinates.max{ $0.latitude < $1.latitude }!.latitude - minLat
            let dLon = coordinates.max{ $0.longitude < $1.longitude }!.longitude - minLon
            return coordinate.latitude >= minLat && coordinate.latitude <= minLat + dLat
                   && coordinate.longitude >= minLon && coordinate.longitude <= minLon + dLon
        } else {
            os_log("Cannot detect point inside polygon. No vertices.", type: .debug)
            return false
        }
    }

    func vertexContains(coordinate: CLLocationCoordinate2D) -> Bool {
        if pointCount > 0 {
            for i in 0..<pointCount {
                let distance = MKMapPoint(coordinate).distance(to: MKMapPoint(coordinates[i]))
                if distance < vertexRadius {
                    dragIndex = i
                    return true
                }
            }
            dragIndex = nil
            return false
        } else {
            os_log("Cannot detect point inside vertex. No vertices.", type: .debug)
            dragIndex = nil
            return false
        }
    }

    func computeOffsets(relativeTo coordinate: CLLocationCoordinate2D) {
        offsets.removeAll(keepingCapacity: true)
        for id in 0..<pointCount {
            let dLat = points()[id].coordinate.latitude - coordinate.latitude
            let dLon = points()[id].coordinate.longitude - coordinate.longitude
            offsets.append(CGPoint(x: dLat, y: dLon))
        }
    }

    func movePolygon(following coordinate: CLLocationCoordinate2D) {
        for i in 0..<pointCount {
            let lat = coordinate.latitude + CLLocationDegrees(offsets[i].x)
            let lon = coordinate.longitude + CLLocationDegrees(offsets[i].y)
            updateVertex(at: i, with: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        }
    }

    func moveVertex(following coordinate: CLLocationCoordinate2D) {
        if dragIndex != nil && offsets.count >= dragIndex! {
            let lat = coordinate.latitude + CLLocationDegrees(offsets[dragIndex!].x)
            let lon = coordinate.longitude + CLLocationDegrees(offsets[dragIndex!].y)
            updateVertex(at: dragIndex!, with: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        }
    }
}
