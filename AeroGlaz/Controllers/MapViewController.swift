//
//  MapViewController.swift
//  Aeroglaz
//
//  Created by Evgeny Agamirzov on 4/24/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import os.log

import CoreLocation
import DJISDK
import MapKit
import UIKit

class MapViewController : UIViewController {
    // Stored properties
    private var mapView = MapView()
    private var locationManager = CLLocationManager()
    private var tapRecognizer = UILongPressGestureRecognizer()
    private var panRecognizer = UIPanGestureRecognizer()
    private var user = MovingObject(CLLocationCoordinate2D(), 0.0, .user)
    private var aircraft = MovingObject(CLLocationCoordinate2D(), 0.0, .aircraft)
    private var home = MovingObject(CLLocationCoordinate2D(), 0.0, .home)
    private var missionPolygon: MissionPolygon?

    // Observer properties
    var gridDistance: CGFloat? {
        didSet {
            self.missionPolygon?.gridDistance = gridDistance
        }
    }
    var gridAngle: CGFloat? {
        didSet {
            self.missionPolygon?.gridAngle = gridAngle
        }
    }

    // Computed properties
    var userLocation: CLLocationCoordinate2D? {
        return objectPresentOnMap(user) ? user.coordinate : nil
    }

    // Notifyer properties
    var logConsole: ((_ message: String, _ type: OSLogType) -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)

        mapView.delegate = self
        mapView.register(MovingObjectView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(MovingObject.self))
        view = mapView

        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()

        tapRecognizer.delegate = self
        tapRecognizer.minimumPressDuration = 1
        tapRecognizer.addTarget(self, action: #selector(handleTap(sender:)))

        panRecognizer.delegate = self
        panRecognizer.minimumNumberOfTouches = 1
        panRecognizer.maximumNumberOfTouches = 1
        panRecognizer.addTarget(self, action: #selector(handlePolygonDrag(sender:)))

        registerListeners()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        repositionLegalLabels()
    }
}

// Public methods
extension MapViewController {
    func trackUser(_ enable: Bool) -> Bool {
        if trackObject(user, enable) {
            let _ = trackObject(aircraft, false)
            return true
        } else {
            logConsole?("Unable to track user. User location unknown", .error)
            return false
        }
    }

    func trackAircraft(_ enable: Bool) -> Bool {
        if trackObject(aircraft, enable) {
            let _ = trackObject(user, false)
            return true
        } else {
            logConsole?("Unable to track aircraft. Aircraft location unknown.", .error)
            return false
        }
    }

    func missionCoordinates() -> [CLLocationCoordinate2D] {
        if let missionPolygon = self.missionPolygon {
            return missionPolygon.missionCoordinates()
        } else {
            logConsole?("Mission coordinates not set", .error)
            return []
        }
    }

    func repositionLegalLabels() {
        mapView.repositionLegalLabels()
    }
}

// Private methods
extension MapViewController {
    private func registerListeners() {
        Environment.locationService.aircraftLocationListeners.append({ location in
            self.showObject(self.aircraft, location)
            self.missionPolygon?.aircraftLocation = location
        })
        Environment.locationService.aircraftHeadingChanged = { heading in
            if (heading != nil) {
                self.aircraft.heading = heading!
            }
        }
        Environment.locationService.homeLocationChanged = { location in
            self.showObject(self.home, location)
        }
        Environment.missionViewController.stateListeners.append({ state in
            self.missionPolygon?.missionState = state
            if state != nil && state == .editing {
                self.enableMissionPolygonInteration(true)
            } else {
                self.enableMissionPolygonInteration(false)
            }
        })
    }

    private func enableMissionPolygonInteration(_ enable: Bool) {
        if enable {
            mapView.addGestureRecognizer(tapRecognizer)
            mapView.addGestureRecognizer(panRecognizer)
        } else {
            mapView.removeGestureRecognizer(tapRecognizer)
            mapView.removeGestureRecognizer(panRecognizer)
        }
    }

    private func enableMapInteraction(_ enable: Bool) {
        mapView.isScrollEnabled = enable
        mapView.isZoomEnabled = enable
        mapView.isUserInteractionEnabled = enable
    }

    private func objectPresentOnMap(_ object: MovingObject) -> Bool {
        return mapView.annotations.contains(where: { annotation in
            return annotation as? MovingObject == object
        })
    }

    private func showObject(_ object: MovingObject, _ location: CLLocation?) {
        if location != nil {
            object.coordinate = location!.coordinate
            if !objectPresentOnMap(object) {
                mapView.addAnnotation(object)
            }
        } else if objectPresentOnMap(object) {
            mapView.removeAnnotation(object)
        }
    }

    private func trackObject(_ object: MovingObject, _ enable: Bool) -> Bool {
        if objectPresentOnMap(object) {
            object.isTracked = enable
            if enable {
                focusOnCoordinate(object.coordinate)
                object.coordinateChanged = { coordinate in
                    self.focusOnCoordinate(coordinate)
                }
            } else {
                object.coordinateChanged = nil
            }
            return true
        } else {
            return false
        }
    }

    func focusOnCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate,
                                        latitudinalMeters: CLLocationDistance(exactly: 200)!,
                                        longitudinalMeters: CLLocationDistance(exactly: 200)!)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }

    private func movingObjectView(for movingObject: MovingObject, on mapView: MKMapView) -> MovingObjectView? {
        let movingObjectView = mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(MovingObject.self), for: movingObject) as? MovingObjectView
        if movingObjectView != nil {
            switch movingObject.type {
                case .user:
                    movingObject.headingChanged = { heading in
                        movingObjectView!.onHeadingChanged(heading)
                    }
                    let image = #imageLiteral(resourceName: "userPin")
                    movingObjectView!.image = image.color(Colors.Overlay.userLocationColor)
                case .aircraft:
                    movingObject.headingChanged = { heading in
                        movingObjectView!.onHeadingChanged(heading)
                    }
                    let image = #imageLiteral(resourceName: "aircraftPin")
                    movingObjectView!.image = image.color(Colors.Overlay.aircraftLocationColor)
                case .home:
                    movingObjectView!.image = #imageLiteral(resourceName: "homePin")
            }
        }
        return movingObjectView
    }
}

// Display annotations and renderers
extension MapViewController : MKMapViewDelegate {    
    internal func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?
        if let annotation = annotation as? MovingObject {
            annotationView = movingObjectView(for: annotation, on: mapView)
        }
        return annotationView
    }

    internal func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for view in views {
            if let movingObjectView = view as? MovingObjectView {
                movingObjectView.addedToMapView()
            }
        }
    }

    internal func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        switch newState {
            case .starting:
                view.dragState = .dragging
            case .ending, .canceling:
                view.dragState = .none
            default:
                break
        }
    }

    internal func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MissionRenderer(overlay: overlay)
        missionPolygon?.renderer = renderer
        return renderer
    }

    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        repositionLegalLabels()
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
       repositionLegalLabels()
    }
}

// Handle custom gestures
extension MapViewController : UIGestureRecognizerDelegate {
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @objc private func handleTap(sender: UIGestureRecognizer) {
        if sender.state == .began && self.missionPolygon != nil {
            let touchCoordinate = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
            if self.missionPolygon!.vertexContainsCoordinate(touchCoordinate) {
                self.missionPolygon!.removeVetrex()
            } else {
                self.missionPolygon!.addVetrex(at: touchCoordinate)
            }
        }
    }

    @objc private func handlePolygonDrag(sender: UIGestureRecognizer) {
        let touchCoordinate = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
        if let polygon = self.missionPolygon {
            let canDragPolygon = polygon.bodyContainsCoordinate(touchCoordinate)
            let canDragVertex = polygon.vertexContainsCoordinate(touchCoordinate)

            if !canDragVertex && !canDragPolygon {
                enableMapInteraction(true)
            } else if sender.state == .began {
                enableMapInteraction(false)
                polygon.computeVertexOffsets(relativeTo: touchCoordinate)
            } else if sender.state == .changed && canDragVertex {
                polygon.moveVertex(to: touchCoordinate)
            } else if sender.state == .changed && canDragPolygon {
                polygon.movePolygon(to: touchCoordinate)
            } else if sender.state == .ended {
                enableMapInteraction(true)
            }
        } else {
            enableMapInteraction(true)
        }
    }
}

// Handle user location and heading updates
extension MapViewController : CLLocationManagerDelegate {
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newCoordinate = locations[0].coordinate
        if (objectPresentOnMap(user)) {
            user.coordinate = newCoordinate
        } else {
            user = MovingObject(newCoordinate, 0.0, .user)
            mapView.addAnnotation(user)
            focusOnCoordinate(user.coordinate)
            if missionPolygon == nil {
                let lat = user.coordinate.latitude
                let lon = user.coordinate.longitude
                let span = 0.0004
                let polygonCoordinates = [
                    CLLocationCoordinate2D(latitude: lat - span, longitude: lon - span),
                    CLLocationCoordinate2D(latitude: lat - span, longitude: lon + span),
                    CLLocationCoordinate2D(latitude: lat + span, longitude: lon + span),
                    CLLocationCoordinate2D(latitude: lat + span, longitude: lon - span)
                ]
                missionPolygon = MissionPolygon(polygonCoordinates)
                self.mapView.addOverlay(missionPolygon!)
            }
        }
    }

    internal func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if (objectPresentOnMap(user)) {
            user.heading = newHeading.trueHeading
        }
    }
}
