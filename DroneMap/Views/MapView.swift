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
class MovingObject : MKPointAnnotation {
    weak var headingDelegate: HeadingDelegate?
    var type: MovingObjectType
    var heading: CLLocationDirection {
        didSet {
            headingDelegate?.headingChanged(heading)
        }
    }
    
    init(_ coordinate: CLLocationCoordinate2D, _ heading: CLLocationDirection,  _ type: MovingObjectType) {
        self.type = type
        self.heading = heading
        super.init()
        self.coordinate = coordinate
    }
}

class MovingObjectView : MKAnnotationView , HeadingDelegate {
    func headingChanged(_ heading: CLLocationDirection) {
        UIView.animate(withDuration: 0.1, animations: { [unowned self] in
            self.transform = CGAffineTransform(rotationAngle: CGFloat(heading / 180 * .pi))
        })
    }
}

/*************************************************************************************************/
class PolygonVertex : MKPointAnnotation {
    var id: Int
    
    init(_ coordinate: CLLocationCoordinate2D, _ id: Int) {
        self.id = id
        super.init()
        self.coordinate = coordinate
    }
}

class PolygonVertexView : MKAnnotationView {
    private var positionChangeFired = false
    weak var positionDelegate: PositionDelegate?
    override var center: CGPoint {
        didSet {
            guard let annotation = self.annotation as? PolygonVertex else {
                return
            }
            guard self.dragState == .dragging else {
                return
            }
            guard !positionChangeFired else {
                return
            }
            
            // The polygon renderer shall be redrawn every time the vertex position
            // changes. Though, the position change rate is way too fast for heavy
            // computations associated with the renderer update to keep up. As a result,
            // computationally expensive operations are queued which slows down the
            // entire application. Thus, limit the update rate to make redrawing smooth
            // and unnoticable to the user.
            positionChangeFired = true
            positionDelegate?.positionChanged(center, annotation.id)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.positionChangeFired = false
            }
        }
    }
}

/*************************************************************************************************/
class PolygonRenderer : MKOverlayRenderer {
    var gridDelta: CGFloat
    
    init(_ overlay: MKOverlay, _ gridDelta: CGFloat) {
        self.gridDelta = gridDelta
        super.init(overlay: overlay)
    }
    
    func setGridDelta(_ gridDelta: CGFloat) {
        self.gridDelta = gridDelta
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        let polygon = self.overlay as? MKPolygon
        guard polygon != nil else {
            return
        }

        var rawPoints: [CGPoint] = []
        for id in 0..<polygon!.pointCount {
            rawPoints.append(point(for: polygon!.points()[id]))
        }
        
        let pointSet = PointSet(rawPoints, gridDelta)
        
        let polygonPath = CGMutablePath()
        polygonPath.addLines(between: pointSet.hullPoints)
        polygonPath.addLine(to: pointSet.hullPoints.first!)
        context.addPath(polygonPath)
        context.setFillColor(red: 86.0, green: 167.0, blue: 20.0, alpha: 0.5)
        context.drawPath(using: .fill)
        
        let gridPath = CGMutablePath()
        gridPath.addLines(between: pointSet.gridPoints)
        context.setStrokeColor(UIColor.yellow.cgColor)
        context.setLineWidth(MKRoadWidthAtZoomScale(zoomScale) * 0.5)
        context.addPath(gridPath)
        context.drawPath(using: .stroke)
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
