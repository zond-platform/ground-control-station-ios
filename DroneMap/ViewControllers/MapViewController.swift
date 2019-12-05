//
//  TabBarController.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/24/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

enum MovingObjectType {
    case aircraft
    case home
    case user
}

/*************************************************************************************************/
class MapViewController : UIViewController {
    private var mapView: MapView!
    private var locationManager: CLLocationManager!
    private var env: Environment!

    private var user: MovingObject!
    private var aircraft: MovingObject!
    private var home: MovingObject!
    
    private var polygonVertices: [PolygonVertex] = []
    private var polygon: MKPolygon!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ env: Environment) {
        super.init(nibName: nil, bundle: nil)
        self.env = env

        env.locationService().addDelegate(self)
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
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        tapRecognizer.delegate = self
        panRecognizer.delegate = self
        panRecognizer.minimumNumberOfTouches = 1
        panRecognizer.maximumNumberOfTouches = 1
        mapView.addGestureRecognizer(tapRecognizer)
        mapView.addGestureRecognizer(panRecognizer)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func userLocation() -> CLLocationCoordinate2D? {
        return user.coordinate
    }

    func enableMissionEditing(_ enable: Bool) {
        if !enable {
            mapView.removeAnnotations(polygonVertices)
            mapView.removeOverlay(polygon)
            return
        }
        
        // TODO: Build default polygon based on current map region
        let lat = user.coordinate.latitude
        let lon = user.coordinate.longitude
        let polygonCoordinates = [CLLocationCoordinate2D(latitude: lat - 0.0002, longitude: lon - 0.0002),
                                  CLLocationCoordinate2D(latitude: lat - 0.0002, longitude: lon + 0.0002),
                                  CLLocationCoordinate2D(latitude: lat + 0.0002, longitude: lon + 0.0002),
                                  CLLocationCoordinate2D(latitude: lat + 0.0002, longitude: lon - 0.0002)]
        
        if polygonVertices.isEmpty {
            for id in 0..<polygonCoordinates.count {
                polygonVertices.append(PolygonVertex(polygonCoordinates[id], id))
            }
        }
        
        if polygon == nil {
            polygon = MKPolygon(coordinates: polygonCoordinates, count: polygonCoordinates.count)
        }

        mapView.addOverlay(polygon)
        mapView.addAnnotations(polygonVertices)
    }
}

/*************************************************************************************************/
extension MapViewController : MKMapViewDelegate {    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?
        
        if let annotation = annotation as? MovingObject {
            let movingObjectView = mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(MovingObject.self), for: annotation) as? MovingObjectView
            switch annotation.type {
                case .user:
                    annotation.headingDelegate = movingObjectView
                    movingObjectView!.image = #imageLiteral(resourceName: "userPin")
                case .aircraft:
                    annotation.headingDelegate = movingObjectView
                    movingObjectView!.image = #imageLiteral(resourceName: "aircraftPin")
                case .home:
                    movingObjectView!.image = #imageLiteral(resourceName: "homePin")
            }
            annotationView = movingObjectView
        } else if let annotation = annotation as? PolygonVertex {
            let polygonVertexView = mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(PolygonVertex.self), for: annotation) as? PolygonVertexView
            polygonVertexView!.image = #imageLiteral(resourceName: "polygonPin")
            polygonVertexView!.isDraggable = true
            polygonVertexView!.positionDelegate = mapView.renderer(for: polygon) as? PolygonRenderer
            mapView.bringSubviewToFront(polygonVertexView!)
            annotationView = polygonVertexView
        }

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        switch newState {
            case .starting:
                view.dragState = .dragging
            case .ending, .canceling:
                view.dragState = .none
            default:
                break
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return PolygonRenderer(overlay, 10.0, self.mapView)
    }
}

/*************************************************************************************************/
extension MapViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    private func enableMapInteraction(_ enable: Bool) {
        mapView.isScrollEnabled = enable
        mapView.isZoomEnabled = enable
        mapView.isUserInteractionEnabled = enable
    }

    @objc func handleTap(sender: UIGestureRecognizer) {
        if sender.state == .ended {
            let _ = mapView.convert(sender.location(in: mapView), toCoordinateFrom: self.view)
        }
    }

    @objc func handlePan(sender: UIGestureRecognizer) {
        let viewPoint = sender.location(in: mapView)
        let mapCoordinate = mapView.convert(viewPoint, toCoordinateFrom: self.view)
        if polygon == nil {
            enableMapInteraction(true)
            return
        }
        let renderer = mapView.renderer(for: polygon)
        if renderer == nil {
            enableMapInteraction(true)
            return
        }
        let polygonRenderer = renderer as? PolygonRenderer
        if polygonRenderer == nil {
            enableMapInteraction(true)
            return
        }
        if !polygonRenderer!.boundingRegion().contains(MKMapPoint(mapCoordinate)) {
            enableMapInteraction(true)
            return
        }
        for vertex in polygonVertices {
            if mapView.view(for: vertex)?.dragState == .dragging {
                enableMapInteraction(true)
                return
            }
        }

        if sender.state == .began {
            for vertex in polygonVertices {
                vertex.compute(displacementTo: mapCoordinate)
            }
            enableMapInteraction(false)
        } else if sender.state == .changed {
            for vertex in polygonVertices {
                vertex.move(relativeTo: mapCoordinate)
                polygon.points()[vertex.id] = MKMapPoint(vertex.coordinate)
                polygonRenderer!.redraw()
            }
        } else if sender.state == .ended {
            enableMapInteraction(true)
        }
    }
}

/*************************************************************************************************/
extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newCoordinate = locations[0].coordinate
        if (user != nil) {
            user.coordinate = newCoordinate
            return
        }
        user = MovingObject(newCoordinate, 0.0, .user)
        mapView.addAnnotation(user)
        mapView.showAnnotations([user], animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if (user != nil) {
            // Displace user heading by 90 degrees because of the landscape orientation.
            // Since only landscape orientation is allowed in the application settings
            // there are only two options: left and right. Thus, only two possible offsets.
            let offset = UIDevice.current.orientation == .landscapeLeft ? 90.0 : -90.0
            user.heading = newHeading.trueHeading + offset
        }
    }
}

/*************************************************************************************************/
extension MapViewController : LocationServiceDelegate {
    func aircraftLocationChanged(_ location: CLLocation) {
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

    func aircraftHeadingChanged(_ heading: CLLocationDirection) {
        if (aircraft != nil) {
            aircraft.heading = heading
        }
    }

    func homeLocationChanged(_ location: CLLocation) {
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

/*************************************************************************************************/
extension MapViewController : ConnectionServiceDelegate {
    func statusChanged(_ status: ConnectionStatus) {
        if status == .disconnected {
            mapView.removeAnnotation(aircraft)
            mapView.removeAnnotation(home)
        }
    }
}

