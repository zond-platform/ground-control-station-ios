//
//  MapViewController.swift
//  DroneMap
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
    private var mapView: MapView!
    private var locationManager: CLLocationManager!
    private var polygonVertices: [PolygonVertex] = []
    private var polygon: MissionPolygon!
    private var user = MovingObject(CLLocationCoordinate2D(), 0.0, .user)
    private var aircraft = MovingObject(CLLocationCoordinate2D(), 0.0, .aircraft)
    private var home = MovingObject(CLLocationCoordinate2D(), 0.0, .home)
    var missionEditingEnabled = false

    // Observer properties
    var gridDistance: CGFloat = 10.0 {
        didSet {
            guard polygon != nil else {
                return
            }
            polygon.gridDistance = gridDistance
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

        mapView = MapView()
        mapView.delegate = self
        mapView.register(MovingObjectView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(MovingObject.self))
        mapView.register(PolygonVertexView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(PolygonVertex.self))
        view = mapView

        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePolygonDrag(sender:)))
        tapRecognizer.delegate = self
        panRecognizer.delegate = self
        panRecognizer.minimumNumberOfTouches = 1
        panRecognizer.maximumNumberOfTouches = 1
        mapView.addGestureRecognizer(tapRecognizer)
        mapView.addGestureRecognizer(panRecognizer)
        registerListeners()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mapView.moveLegalLabel()
    }
}

// Public methods
extension MapViewController {
    func trackUser(_ enable: Bool) -> Bool {
        if trackObject(user, enable) {
            let _ = trackObject(aircraft, false)
            return true
        } else {
            logConsole?("Failed to track user", .error)
            return false
        }
    }

    func trackAircraft(_ enable: Bool) -> Bool {
        if trackObject(aircraft, enable) {
            let _ = trackObject(user, false)
            return true
        } else {
            logConsole?("Failed to track aircraft", .error)
            return false
        }
    }

    func enableMissionEditing(_ enable: Bool) {
        missionEditingEnabled = enable
        if missionEditingEnabled {
            let lat = user.coordinate.latitude
            let lon = user.coordinate.longitude
            let polygonCoordinates = [
                CLLocationCoordinate2D(latitude: lat - 0.0002, longitude: lon - 0.0002),
                CLLocationCoordinate2D(latitude: lat - 0.0002, longitude: lon + 0.0002),
                CLLocationCoordinate2D(latitude: lat + 0.0002, longitude: lon + 0.0002),
                CLLocationCoordinate2D(latitude: lat + 0.0002, longitude: lon - 0.0002)
            ]
            if polygonVertices.isEmpty {
                for id in 0..<polygonCoordinates.count {
                    polygonVertices.append(PolygonVertex(polygonCoordinates[id], id))
                }
            }
            if polygon == nil {
                polygon = MissionPolygon(polygonCoordinates, mapView)
            }
            mapView.addAnnotations(polygonVertices)
            mapView.addOverlay(polygon)
            mapView.showAnnotations([user], animated: true)
        } else if polygon != nil {
            mapView.removeAnnotations(polygonVertices)
            mapView.removeOverlay(polygon)
        }
    }
    
    func missionCoordinates() -> [CLLocationCoordinate2D] {
        if missionEditingEnabled && polygon != nil {
            return polygon.missionCoordinates()
        } else {
            logConsole?("Mission coordinates not set", .error)
            return []
        }
    }
}

// Private methods
extension MapViewController {
    private func registerListeners() {
        Environment.locationService.aircraftLocationListeners.append({ location in
            self.showObject(self.aircraft, location)
        })
        Environment.locationService.aircraftHeadingChanged = { heading in
            if (heading != nil) {
                let iconOrientationOffset = -45.0
                self.aircraft.heading = heading! + iconOrientationOffset
            }
        }
        Environment.locationService.homeLocationChanged = { location in
            self.showObject(self.home, location)
        }
        Environment.missionViewController.stateListeners.append({ state in
            if state == nil {
                self.enableMissionEditing(false)
            } else {
                self.enableMissionEditing(true)
            }
        })
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
                mapView.setCenter(object.coordinate, animated: true)
                object.coordinateChanged = { coordinate in
                    self.mapView.setCenter(coordinate, animated: true)
                }
            } else {
                object.coordinateChanged = nil
            }
            return true
        } else {
            return false
        }
    }

    private func enableMapInteraction(_ enable: Bool) {
        mapView.isScrollEnabled = enable
        mapView.isZoomEnabled = enable
        mapView.isUserInteractionEnabled = enable
    }

    private func canDragPolygon(with touchCoordinate: CLLocationCoordinate2D) -> Bool {
        if polygon == nil {
            return false
        }
        for vertex in polygonVertices {
            if mapView.view(for: vertex)?.dragState == .dragging {
                return false
            }
        }
        if !polygon.containsCoordinate(touchCoordinate) {
            return false
        }
        return true
    }

    private func movingObjectView(for movingObject: MovingObject, on mapView: MKMapView) -> MovingObjectView? {
        let movingObjectView = mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(MovingObject.self), for: movingObject) as? MovingObjectView
        if movingObjectView != nil {
            switch movingObject.type {
                case .user:
                    movingObject.delegate = movingObjectView
                    let image = #imageLiteral(resourceName: "userPin")
                    movingObjectView!.image = image.color(Colors.Overlay.userLocationColor)
                case .aircraft:
                    movingObject.delegate = movingObjectView
                    let image = #imageLiteral(resourceName: "aircraftPin")
                    movingObjectView!.image = image.color(Colors.Overlay.aircraftLocationColor)
                case .home:
                    movingObjectView!.image = #imageLiteral(resourceName: "homePin")
            }
        }
        return movingObjectView
    }

    private func polygonVertexView(for polygonVertex: PolygonVertex, on mapView: MKMapView) -> PolygonVertexView {
        let polygonVertexView = mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(PolygonVertex.self), for: polygonVertex) as? PolygonVertexView
        if polygonVertexView != nil {
            polygonVertex.delegate = polygon
            polygonVertexView!.delegate = polygon
            polygonVertexView!.image = #imageLiteral(resourceName: "polygonPin")
            polygonVertexView!.isDraggable = true
        }
        return polygonVertexView!
    }
}

// Display annotations and renderers
extension MapViewController : MKMapViewDelegate {    
    internal func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?
        if let annotation = annotation as? MovingObject {
            annotationView = movingObjectView(for: annotation, on: mapView)
        } else if let annotation = annotation as? PolygonVertex {
            annotationView = polygonVertexView(for: annotation, on: mapView)
        }
        return annotationView
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
        let renderer = MissionRenderer(overlay, gridDistance)
        if let overlay = overlay as? MissionPolygon {
            overlay.delegate = renderer
        }
        return renderer
    }

    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        self.mapView.moveLegalLabel()
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
       self.mapView.moveLegalLabel()
    }
}

// Handle custom gestures
extension MapViewController : UIGestureRecognizerDelegate {
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @objc private func handleTap(sender: UIGestureRecognizer) {}

    @objc private func handlePolygonDrag(sender: UIGestureRecognizer) {
        let touchPoint = sender.location(in: mapView)
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        if !canDragPolygon(with: touchCoordinate) {
            enableMapInteraction(true)
        } else if sender.state == .began {
            for vertex in polygonVertices {
                vertex.compute(displacementTo: touchCoordinate)
            }
            enableMapInteraction(false)
        } else if sender.state == .changed {
            for vertex in polygonVertices {
                vertex.move(relativeTo: touchCoordinate)
            }
        } else if sender.state == .ended {
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
            mapView.showAnnotations([user], animated: true)
        }
    }

    internal func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if (objectPresentOnMap(user)) {
            // Displace user heading by 90 degrees because of the landscape orientation.
            // Since only landscape orientation is allowed in the application settings
            // there are only two options: left and right. Thus, only two possible offsets.
            let deviceOrientationOffset = UIDevice.current.orientation == .landscapeLeft ? 90.0 : -90.0
            let iconOrientationOffset = -45.0
            user.heading = newHeading.trueHeading + deviceOrientationOffset + iconOrientationOffset
        }
    }
}
