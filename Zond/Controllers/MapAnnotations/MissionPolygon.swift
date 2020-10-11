//
//  MutablePolygon.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 06.07.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import os.log

import UIKit
import MapKit

fileprivate let maxVertexCount: Int = 20



class MissionPolygon : MKPolygon {
    // Stored properties
    var dragIndex: Int?
    var vertexRadius: CLLocationDistance = 50
    var coordinates: [CLLocationCoordinate2D] = []
    private var offsets: [CGPoint] = []

    // Computed properties
    var center: CLLocationCoordinate2D? {
        if coordinates.count > 0 {
            let lat = coordinates.reduce(0, { $0 + $1.latitude }) / CLLocationDegrees(coordinates.count)
            let lon = coordinates.reduce(0, { $0 + $1.longitude }) / CLLocationDegrees(coordinates.count)
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        } else {
            os_log("Cannot compute center. No vertices.", type: .debug)
            return nil
        }
    }
    override var boundingMapRect: MKMapRect {
        MKMapRect.world
    }

    // Observer properties
    var gridDistance: CGFloat? {
        didSet {
            updated?()
        }
    }
    var gridAngle: CGFloat? {
        didSet {
            updated?()
        }
    }
    var missionState: MissionState? {
        didSet {
            updated?()
        }
    }
    var aircraftLocation: CLLocation? {
        willSet {
            if newValue == nil {
                updated?()
            }
        }
        didSet {
            if oldValue == nil {
                updated?()
            }
        }
    }

    // Notifyer properties
    var updated: (() -> Void)?

    convenience init?(_ coordinates: [CLLocationCoordinate2D]) {
        var preallocatedCoordinates = Array(repeating: CLLocationCoordinate2D(), count: maxVertexCount)
        preallocatedCoordinates.replaceSubrange(0...coordinates.count - 1, with: coordinates)
        self.init(coordinates: preallocatedCoordinates, count: maxVertexCount)
        self.coordinates = coordinates
        if coordinates.count <= maxVertexCount {
            syncCoordinates()
        } else {
            return nil
        }
    }
}

// Private methods
extension MissionPolygon {
    private func syncCoordinates() {
        for i in 0..<coordinates.count {
            points()[i] = MKMapPoint(coordinates[i])
        }
        for i in coordinates.count..<maxVertexCount {
            points()[i] = MKMapPoint()
        }
        updated?()
    }
}

// Public methods
extension MissionPolygon {
    func appendVetrex(with coordinate: CLLocationCoordinate2D) {
        if coordinates.count + 1 <= maxVertexCount {
            points()[coordinates.count] = MKMapPoint(coordinate)
            coordinates.append(coordinate)
            updated?()
        } else {
            os_log("Cannot add vertex. Maximum vertex count reached.", type: .debug)
        }
    }
    
    func updateVertex(at i: Int, with coordinate: CLLocationCoordinate2D) {
        if !coordinates.isEmpty && i >= 0 && i < coordinates.count {
            coordinates[i] = coordinate
            points()[i] = MKMapPoint(coordinate)
        } else {
            os_log("Cannot remove vertex. Invalid index.", type: .debug)
        }
    }

    func removeVetrex(at i: Int) {
        if !coordinates.isEmpty && i >= 0 && i < coordinates.count {
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
        if coordinates.count <= maxVertexCount {
            self.coordinates = coordinates
            syncCoordinates()
        } else {
            os_log("Cannot replace vertices. Maximum vertex count exceeded.", type: .debug)
        }
    }

    func bodyContains(coordinate: CLLocationCoordinate2D) -> Bool {
        if coordinates.count > 0 {
            let rects = coordinates.lazy.map { MKMapRect(origin: MKMapPoint($0), size: MKMapSize()) }
            let rect = rects.reduce(MKMapRect.null) { $0.union($1) }
            return rect.contains(MKMapPoint(coordinate))
        } else {
            os_log("Cannot detect point inside polygon. No vertices.", type: .debug)
            return false
        }
    }

    func vertexContains(coordinate: CLLocationCoordinate2D) -> Bool {
        if coordinates.count > 0 {
            for i in 0..<coordinates.count {
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
        for id in 0..<coordinates.count {
            let dLat = points()[id].coordinate.latitude - coordinate.latitude
            let dLon = points()[id].coordinate.longitude - coordinate.longitude
            offsets.append(CGPoint(x: dLat, y: dLon))
        }
    }

    func movePolygon(following coordinate: CLLocationCoordinate2D) {
        for i in 0..<coordinates.count {
            let lat = coordinate.latitude + CLLocationDegrees(offsets[i].x)
            let lon = coordinate.longitude + CLLocationDegrees(offsets[i].y)
            updateVertex(at: i, with: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        }
        updated?()
    }

    func moveVertex(following coordinate: CLLocationCoordinate2D) {
        if dragIndex != nil && offsets.count >= dragIndex! {
            let lat = coordinate.latitude + CLLocationDegrees(offsets[dragIndex!].x)
            let lon = coordinate.longitude + CLLocationDegrees(offsets[dragIndex!].y)
            updateVertex(at: dragIndex!, with: CLLocationCoordinate2D(latitude: lat, longitude: lon))
            updated?()
        }
    }
}
