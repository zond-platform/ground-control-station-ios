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

enum AnnotationType {
    case aircraft
    case home
    case user
    case polygon
}

extension AnnotationType : CaseIterable {}

/*************************************************************************************************/
class MapViewController : UIViewController {
    private var mapView: MapView!
    private var locationManager: CLLocationManager!
    private var env: Environment!

    private var userAnnotation: Annotation!
    private var aircraftAnnotation: Annotation!
    private var homeAnnotation: Annotation!
    private var polygonAnnotations: [Annotation] = []
    
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
        mapView.register(AnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(Annotation.self))
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func userLocation() -> CLLocationCoordinate2D? {
        return userAnnotation.coordinate
    }
    
    func enableMissionEditing(_ enable: Bool) {
        if !enable {
            mapView.removeAnnotations(polygonAnnotations)
            mapView.removeOverlay(polygon)
            return
        }
        
        // TODO: Build default polygon based on current map region
        let lat = userAnnotation.coordinate.latitude
        let lon = userAnnotation.coordinate.longitude
        let polygonCoordinates = [CLLocationCoordinate2D(latitude: lat - 0.0001, longitude: lon - 0.0001),
                                  CLLocationCoordinate2D(latitude: lat - 0.0001, longitude: lon + 0.0001),
                                  CLLocationCoordinate2D(latitude: lat + 0.0001, longitude: lon + 0.0001),
                                  CLLocationCoordinate2D(latitude: lat + 0.0001, longitude: lon - 0.0001)]
        
        if polygonAnnotations.isEmpty {
            for id in 0..<polygonCoordinates.count {
                polygonAnnotations.append(Annotation(polygonCoordinates[id], 0.0, .polygon, id))
            }
        }
        
        if polygon == nil {
            polygon = MKPolygon(coordinates: polygonCoordinates, count: polygonCoordinates.count)
        }
        
        mapView.addAnnotations(polygonAnnotations)
        mapView.addOverlay(polygon)
    }
}

/*************************************************************************************************/
extension MapViewController : MKMapViewDelegate {    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(Annotation.self)) as? AnnotationView
        if (annotationView == nil) {
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: NSStringFromClass(Annotation.self))
        } else {
            annotationView!.annotation = annotation
        }

        if let annotation = annotation as? Annotation {
            switch annotation.type {
                case .user:
                    annotation.headingDelegate = annotationView
                    annotationView!.image = #imageLiteral(resourceName: "userPin")
                case .aircraft:
                    annotation.headingDelegate = annotationView
                    annotationView!.image = #imageLiteral(resourceName: "aircraftPin")
                case .home:
                    annotationView!.image = #imageLiteral(resourceName: "homePin")
                case .polygon:
                    annotationView!.image = #imageLiteral(resourceName: "polygonPin")
                    annotationView!.isDraggable = true
                    annotationView!.positionDelegate = self
            }
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
        return PolygonRenderer(overlay: overlay)
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
extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newCoordinate = locations[0].coordinate
        if (userAnnotation != nil) {
            userAnnotation.coordinate = newCoordinate
            return
        }
        userAnnotation = Annotation(newCoordinate, 0.0, .user)
        mapView.addAnnotation(userAnnotation)
        mapView.showAnnotations([userAnnotation], animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if (userAnnotation != nil) {
            // Displace user heading by 90 degrees because of the landscape orientation.
            // Since only landscape orientation is allowed in the application settings
            // there are only two options: left and right. Thus, only two possible offsets.
            let offset = UIDevice.current.orientation == .landscapeLeft ? 90.0 : -90.0
            userAnnotation.heading = newHeading.trueHeading + offset
        }
    }
}

/*************************************************************************************************/
extension MapViewController : LocationServiceDelegate {
    func aircraftLocationChanged(_ location: CLLocation) {
        if (aircraftAnnotation == nil) {
            aircraftAnnotation = Annotation(location.coordinate, 0.0, .aircraft)
        }

        if (mapView.annotations.contains(where: { (annotation) -> Bool in
            return annotation as? Annotation == aircraftAnnotation
        })) {
            aircraftAnnotation.coordinate = location.coordinate
        } else {
            mapView.addAnnotation(aircraftAnnotation)
        }
    }

    func aircraftHeadingChanged(_ heading: CLLocationDirection) {
        if (aircraftAnnotation != nil) {
            aircraftAnnotation.heading = heading
        }
    }

    func homeLocationChanged(_ location: CLLocation) {
        if (homeAnnotation == nil) {
            homeAnnotation = Annotation(location.coordinate, 0.0, .home)
        }

        if (mapView.annotations.contains(where: { (annotation) -> Bool in
            return annotation as? Annotation == homeAnnotation
        })) {
            homeAnnotation.coordinate = location.coordinate
        } else {
            mapView.addAnnotation(homeAnnotation)
        }
    }
}

/*************************************************************************************************/
extension MapViewController : ConnectionServiceDelegate {
    func statusChanged(_ status: ConnectionStatus) {
        if status == .disconnected {
            mapView.removeAnnotation(aircraftAnnotation)
            mapView.removeAnnotation(homeAnnotation)
        }
    }
}

