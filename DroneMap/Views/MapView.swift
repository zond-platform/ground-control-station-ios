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

protocol PositionDelegate : AnyObject {
    func positionChanged(_ position: CGPoint, _ id: Int)
}

/*************************************************************************************************/
class Annotation : MKPointAnnotation {
    weak var headingDelegate: HeadingDelegate?
    var type: AnnotationType
    var id: Int?
    var heading: CLLocationDirection {
        didSet {
            headingDelegate?.headingChanged(heading)
        }
    }
    
    init(_ coordinate: CLLocationCoordinate2D, _ heading: CLLocationDirection,  _ type: AnnotationType, _ id: Int? = .none) {
        self.type = type
        self.id = id
        self.heading = heading
        super.init()
        self.coordinate = coordinate
    }
}

/*************************************************************************************************/
class AnnotationView : MKAnnotationView {
    weak var positionDelegate: PositionDelegate?
    override var center: CGPoint {
        didSet {
            guard let annotation = annotation as? Annotation else {
                return
            }
            guard annotation.id != nil else {
                return
            }
            positionDelegate?.positionChanged(center, annotation.id!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
}

extension AnnotationView : HeadingDelegate {
    func headingChanged(_ heading: CLLocationDirection) {
        UIView.animate(withDuration: 0.1, animations: { [unowned self] in
            self.transform = CGAffineTransform(rotationAngle: CGFloat(heading / 180 * .pi))
        })
    }
}

/*************************************************************************************************/
class PolygonRenderer : MKOverlayRenderer {
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        let polygon = self.overlay as? MKPolygon
        guard polygon != nil else {
            return
        }
        
        let rawPoints = self.rawPoints()
        context.beginPath()
        context.addLines(between: rawPoints)
        context.addLine(to: rawPoints.first!)
        context.setFillColor(red: 86.0, green: 167.0, blue: 20.0, alpha: 0.5)
        context.drawPath(using: .fill)
    }
    
    private func rawPoints() -> [CGPoint] {
        let polygon = self.overlay as? MKPolygon
        guard polygon != nil else {
            return []
        }
        
        var rawPoints: [CGPoint] = []
        for idx in 0..<polygon!.pointCount {
            rawPoints.append(point(for: polygon!.points()[idx]))
        }
        
        return rawPoints
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
        mapType = .satellite
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
