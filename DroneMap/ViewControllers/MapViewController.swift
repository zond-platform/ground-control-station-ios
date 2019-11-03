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
    
    private var surveyGridDelta: CGFloat = 10.0
    
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
        mapView.addGestureRecognizer(tapRecognizer)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func userLocation() -> CLLocationCoordinate2D? {
        return user.coordinate
    }
    
    // TODO: Add distance calculation in any direction
//    func setSurveyGridDelta(forDistance distance: Double) {
//        let earthRadius = 6378137.0
//        let latitude = user.coordinate.latitude
//        let longitude = user.coordinate.longitude
//        
//        // Only latitude distance is calculated
//        let latMetersDelta = distance
//        let lonMetersDelta = 0.0
//        
//        let latitudeDelta = latMetersDelta / earthRadius
//        let longitudeDelta = lonMetersDelta / (earthRadius * cos(Double.pi * latitude / 180.0))
//        
//        let newLatitude = latitude + latitudeDelta * 180.0 / Double.pi
//        let newLongitude = longitude + longitudeDelta * 180.0 / Double.pi
//        let referenceCoordinate = CLLocationCoordinate2D(latitude: newLatitude, longitude: newLongitude)
//        
//        let userPoint = mapView.convert(user.coordinate, toPointTo: mapView)
//        let referencePoint = mapView.convert(referenceCoordinate, toPointTo: mapView)
//        
//        surveyGridDelta = sqrt(pow(userPoint.x - referencePoint.x, 2) + pow(userPoint.y - referencePoint.y, 2))
//    }

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
        
        //setSurveyGridDelta(forDistance: 50.0)
        mapView.addAnnotations(polygonVertices)
        mapView.addOverlay(polygon)
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
            polygonVertexView!.positionDelegate = self
            mapView.bringSubviewToFront(polygonVertexView!)
            annotationView = polygonVertexView
        }

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        
        // TODO: Try replacing with a ternary
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
        return PolygonRenderer(overlay, surveyGridDelta)
    }
}

/*************************************************************************************************/
extension MapViewController : PositionDelegate {
    
    // TODO: Consider sending position directly to the renderer
    func positionChanged(_ position: CGPoint, _ id: Int) {
        
        // Change polygon point
        let point = MKMapPoint(mapView.convert(position, toCoordinateFrom: self.view))
        polygon.points()[id] = point

        // Re-draw the renderer
        if let renderer = mapView.renderer(for: polygon) as? PolygonRenderer {
            renderer.setNeedsDisplay()
        }
    }
}

/*************************************************************************************************/
extension MapViewController {
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let _ = mapView.convert(sender.location(in: mapView), toCoordinateFrom: self.view)
            // TODO: Handle map touch events
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

