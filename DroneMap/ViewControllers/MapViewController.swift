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

protocol HeadingDelegate : AnyObject {
    func headingChanged(_ heading: CLLocationDirection)
}

/*************************************************************************************************/
class MapViewController : UIViewController {
    var userHeadingDelegate: HeadingDelegate?
    var aircraftHeadingDelegate: HeadingDelegate?

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
                    userHeadingDelegate = annotationView as? HeadingDelegate
                    annotationView!.image = #imageLiteral(resourceName: "userPin")
                case .aircraft:
                    aircraftHeadingDelegate = annotationView as? HeadingDelegate
                    annotationView!.image = #imageLiteral(resourceName: "dronePin")
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
            userHeadingDelegate?.headingChanged(newHeading.magneticHeading)
        }
    }
}

/*************************************************************************************************/
extension MapViewController : LocationServiceDelegate {
    func aircraftLocationChanged(_ location: CLLocation) {
        let newCoordinate = location.coordinate
        if (aircraftAnnotation != nil) {
            aircraftAnnotation.coordinate = newCoordinate
            return
        }
        aircraftAnnotation = Annotation(newCoordinate, 0.0, .aircraft)
        mapView.addAnnotation(aircraftAnnotation)
    }

    func aircraftHeadingChanged(_ heading: CLLocationDirection) {
        if (aircraftAnnotation != nil) {
            aircraftHeadingDelegate?.headingChanged(heading)
        }
    }

    func homeLocationChanged(_ location: CLLocation) {}
}

