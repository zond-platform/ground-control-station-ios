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
}

/*************************************************************************************************/
extension MapViewController : MKMapViewDelegate {    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(Annotation.self))
        if (annotationView == nil) {
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: NSStringFromClass(Annotation.self))
        } else {
            annotationView!.annotation = annotation
        }

        if let annotation = annotation as? Annotation {
            switch annotation.type {
                case .user:
                    annotation.headingDelegate = annotationView as? HeadingDelegate
                    annotationView!.image = #imageLiteral(resourceName: "userPin")
                case .aircraft:
                    annotation.headingDelegate = annotationView as? HeadingDelegate
                    annotationView!.image = #imageLiteral(resourceName: "aircraftPin")
                case .home:
                    annotationView!.image = #imageLiteral(resourceName: "homePin")
            }
        }

        return annotationView
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
            // Displace the heading by 90 degrees CCW for landscape orientation (applcation default)
            userAnnotation.heading = newHeading.magneticHeading - 90
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

