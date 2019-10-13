//
//  MapView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/27/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit
import MapKit

protocol HeadingDelegate : AnyObject {
    func headingChanged(_ heading: CLLocationDirection)
}

/*************************************************************************************************/
class Annotation : MKPointAnnotation {
    weak var headingDelegate: HeadingDelegate?
    var type: AnnotationType
    var heading: CLLocationDirection {
        didSet {
            headingDelegate?.headingChanged(heading)
        }
    }
    
    init(_ coordinate: CLLocationCoordinate2D, _ heading: CLLocationDirection,  _ type: AnnotationType) {
        self.type = type
        self.heading = heading
        super.init()
        self.coordinate = coordinate
    }
}

/*************************************************************************************************/
class AnnotationView : MKAnnotationView , HeadingDelegate {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }

    func headingChanged(_ heading: CLLocationDirection) {
        UIView.animate(withDuration: 0.1, animations: { [unowned self] in
            self.transform = CGAffineTransform(rotationAngle: CGFloat(heading / 180 * .pi))
        })
    }
}

/*************************************************************************************************/
class MapView : MKMapView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        // Default initialize with dummy non-zero values for width
        // and height to silence auto layout warnings (allegedly a bug).
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        mapType = .hybridFlyover
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        frame = CGRect(
            x: 0,
            y: 0,
            width: superview?.frame.width ?? 0,
            height: superview?.frame.height ?? 0
        )
    }
}
