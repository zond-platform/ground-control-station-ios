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
    private var annotations: [AnnotationType:Annotation] = [:]
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(_ env: Environment) {
        super.init(nibName: nil, bundle: nil)
        self.env = env
        
        env.locationService().addDelegate(self)
        
        mapView = MapView()
        mapView.delegate = self
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(Annotation.self))
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
    
    private func updateAnnotation(_ location: CLLocation, _ annotationType: AnnotationType) {
        if annotations[annotationType] == nil {
            annotations[annotationType] = Annotation(location.coordinate, annotationType)
            mapView.addAnnotation(annotations[annotationType]!)
            
            // Focus on user annotation when added
            if annotationType == .user {
                mapView.showAnnotations([annotations[annotationType]!], animated: true)
            }
        } else {
            annotations[annotationType]!.coordinate = location.coordinate
        }
    }
    
    func userLocation() -> CLLocationCoordinate2D? {
        return annotations[.user]?.coordinate
    }
}

/*************************************************************************************************/
extension MapViewController : MKMapViewDelegate {    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(Annotation.self), for: annotation)
        if let annotation = annotation as? Annotation {
            switch annotation.type {
                case .user:
                    annotationView.image = #imageLiteral(resourceName: "userPin")
                case .aircraft:
                    annotationView.image = #imageLiteral(resourceName: "dronePin")
                case .home:
                    annotationView.image = #imageLiteral(resourceName: "homePin")
            }
        }
        return annotationView
    }
}

/*************************************************************************************************/
extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateAnnotation(locations[0], .user)
    }
}

/*************************************************************************************************/
extension MapViewController : LocationServiceDelegate {
    func aircraftLocationChanged(_ location: CLLocation) {
        updateAnnotation(location, .aircraft)
    }
    
    func homeLocationChanged(_ location: CLLocation) {
        updateAnnotation(location, .home)
    }
}

