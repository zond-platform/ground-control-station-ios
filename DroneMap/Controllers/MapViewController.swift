//
//  MapViewController.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/24/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController : UIViewController {
    private var mapView: MapView!
    private var locationManager: CLLocationManager!
    private var env: Environment!

    private var user: MovingObject!
    private var aircraft: MovingObject!
    private var home: MovingObject!
    
    private var polygonVertices: [PolygonVertex] = []
    private var polygon: MissionPolygon!
    
    var missionEditingEnabled = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ env: Environment) {
        super.init(nibName: nil, bundle: nil)
        
        self.env = env
        env.locationService().addDelegate(self)

        // TODO: Replace with product service
        env.connectionService().addDelegate(self)

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
    }
}

// Public methods
extension MapViewController {
    func userLocation() -> CLLocationCoordinate2D? {
        return user.coordinate
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
        } else {
            mapView.removeAnnotations(polygonVertices)
            mapView.removeOverlay(polygon)
        }
    }
    
    func missionCoordinates() -> [CLLocationCoordinate2D] {
        if missionEditingEnabled && polygon != nil {
            return polygon.missionCoordinates()
        } else {
            return []
        }
    }
}

// Private methods
extension MapViewController {
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
                    movingObjectView!.image = #imageLiteral(resourceName: "userPin")
                case .aircraft:
                    movingObject.delegate = movingObjectView
                    movingObjectView!.image = #imageLiteral(resourceName: "aircraftPin")
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
        let renderer = MissionRenderer(overlay, 20.0)
        if let overlay = overlay as? MissionPolygon {
            overlay.delegate = renderer
        }
        return renderer
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
        if (user == nil) {
            user = MovingObject(newCoordinate, 0.0, .user)
            mapView.addAnnotation(user)
            mapView.showAnnotations([user], animated: true)
        } else {
            user.coordinate = newCoordinate
        }
    }

    internal func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if (user != nil) {
            // Displace user heading by 90 degrees because of the landscape orientation.
            // Since only landscape orientation is allowed in the application settings
            // there are only two options: left and right. Thus, only two possible offsets.
            let offset = UIDevice.current.orientation == .landscapeLeft ? 90.0 : -90.0
            user.heading = newHeading.trueHeading + offset
        }
    }
}

// Handle aircraft and home position updates
extension MapViewController : LocationServiceDelegate {
    internal func aircraftLocationChanged(_ location: CLLocation) {
        if (aircraft == nil) {
            aircraft = MovingObject(location.coordinate, 0.0, .aircraft)
        }

        if (mapView.annotations.contains(where: { (annotation) -> Bool in
            return annotation as? MovingObject == aircraft
        })) {
            aircraft.coordinate = location.coordinate
        } else {
            mapView.addAnnotation(aircraft)
        }
    }

    internal func aircraftHeadingChanged(_ heading: CLLocationDirection) {
        if (aircraft != nil) {
            aircraft.heading = heading
        }
    }

    internal func homeLocationChanged(_ location: CLLocation) {
        if (home == nil) {
            home = MovingObject(location.coordinate, 0.0, .home)
        }

        if (mapView.annotations.contains(where: { (annotation) -> Bool in
            return annotation as? MovingObject == home
        })) {
            home.coordinate = location.coordinate
        } else {
            mapView.addAnnotation(home)
        }
    }
}

// Monitor aircraft connection status
extension MapViewController : ConnectionServiceDelegate {
    internal func statusChanged(_ status: ConnectionStatus) {
        if status == .disconnected {
            if aircraft != nil {
                mapView.removeAnnotation(aircraft)
            }
            if home != nil {
                mapView.removeAnnotation(home)
            }
        }
    }
}
