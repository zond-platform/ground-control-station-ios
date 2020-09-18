//
//  MissionPolygonTest.swift
//  AeroGlazTests
//
//  Created by Evgeny Agamirzov on 07.07.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import MapKit

import XCTest
@testable import AeroGlaz

class MissionPolygonTest : XCTestCase {
    let coordinates = [
        CLLocationCoordinate2D(latitude: 10, longitude: 10),
        CLLocationCoordinate2D(latitude: 10, longitude: 15),
        CLLocationCoordinate2D(latitude: 15, longitude: 10),
        CLLocationCoordinate2D(latitude: 15, longitude: 15)
    ]

    func testPolygonCreation() {
        let polygon = MissionPolygon(coordinates)
        XCTAssertTrue(polygon != nil)
        XCTAssertEqual(polygon!.coordinates.count, 4)
        XCTAssertEqual(polygon!.center?.latitude, 12.5)
        XCTAssertEqual(polygon!.center?.longitude, 12.5)
    }

    func testPolygonCapacity() {
        let polygon = MissionPolygon(coordinates)
        XCTAssertTrue(polygon != nil)
        polygon!.appendVetrex(with: CLLocationCoordinate2D(latitude: 15, longitude: 20))
        XCTAssertEqual(polygon!.coordinates.count, 5)
    }

    func testPolygonContains() {
        let polygon = MissionPolygon(coordinates)
        XCTAssertTrue(polygon != nil)
        XCTAssertFalse(polygon!.bodyContains(coordinate: CLLocationCoordinate2D(latitude: 15, longitude: 20)))
        XCTAssertTrue(polygon!.bodyContains(coordinate: CLLocationCoordinate2D(latitude: 10, longitude: 15)))
        XCTAssertTrue(polygon!.bodyContains(coordinate: CLLocationCoordinate2D(latitude: 13, longitude: 11)))

        let smallEps = 10e-6
        let bigEps = 10e-2
        XCTAssertTrue(polygon!.vertexContains(coordinate: CLLocationCoordinate2D(latitude: 15, longitude: 10)))
        XCTAssertTrue(polygon!.vertexContains(coordinate: CLLocationCoordinate2D(latitude: 15 + smallEps, longitude: 10 + smallEps)))
        XCTAssertFalse(polygon!.vertexContains(coordinate: CLLocationCoordinate2D(latitude: 15 + bigEps, longitude: 10 + bigEps)))
    }
}
