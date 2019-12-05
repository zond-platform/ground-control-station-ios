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
    func vertexPositionChanged(_ position: CGPoint, _ id: Int)
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
    
    init(_ coordinate: CLLocationCoordinate2D, _ heading: CLLocationDirection, _ type: MovingObjectType) {
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
    public let id: Int
    private var dLat: Double = 0.0
    private var dLon: Double = 0.0

    init(_ coordinate: CLLocationCoordinate2D, _ id: Int) {
        self.id = id
        super.init()
        self.coordinate = coordinate
    }

    func compute(displacementTo coordinate: CLLocationCoordinate2D) {
        dLat = self.coordinate.latitude - coordinate.latitude
        dLon = self.coordinate.longitude - coordinate.longitude
    }

    func move(relativeTo coordinate: CLLocationCoordinate2D) {
        self.coordinate.latitude = coordinate.latitude + dLat
        self.coordinate.longitude = coordinate.longitude + dLon
    }
}

class PolygonVertexView : MKAnnotationView {
    weak var positionDelegate: PositionDelegate?
    override var center: CGPoint {
        didSet {
            guard let annotation = self.annotation as? PolygonVertex else {
                return
            }
            guard self.dragState == .dragging else {
                return
            }
            positionDelegate?.vertexPositionChanged(center, annotation.id)
        }
    }
}

/*************************************************************************************************/
class PolygonRenderer : MKOverlayRenderer , PositionDelegate {
    private var vertexPositionChangeFired = false
    var gridDelta: CGFloat
    var pointSet: PointSet
    var mapView: MapView

    init(_ overlay: MKOverlay, _ gridDelta: CGFloat, _ mapView: MapView) {
        self.gridDelta = gridDelta
        self.pointSet = PointSet()
        self.mapView = mapView
        super.init(overlay: overlay)
    }

    func vertexPositionChanged(_ position: CGPoint, _ id: Int) {
        let polygon = self.overlay as? MKPolygon
        guard polygon != nil else {
            return
        }
        polygon!.points()[id] = MKMapPoint(mapView.convert(position, toCoordinateFrom: mapView))
        redraw()
    }

    func redraw() {
        // The polygon renderer shall be redrawn every time the vertex position
        // changes. Though, the position change rate is way too fast for heavy
        // computations associated with the renderer update to keep up. As a result,
        // computationally expensive operations are queued which slows down the
        // entire application. Thus, limit the update rate to make redrawing smooth
        // and unnoticable to the user.
        if self.vertexPositionChangeFired == false {
            vertexPositionChangeFired = true
            self.setNeedsDisplay()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.vertexPositionChangeFired = false
            }
        }
    }

    func boundingRegion() -> MKMapRect {
        let origin = mapPoint(for: CGPoint(x: Double(pointSet.leftmostPoint!.x),
                                           y: Double(pointSet.lowermostPoint!.y)))
        let size = MKMapSize(width: Double(pointSet.rightmostPoint!.x) - Double(pointSet.leftmostPoint!.x),
                             height: Double(pointSet.uppermostPoint!.y) - Double(pointSet.lowermostPoint!.y))
        return MKMapRect(origin: origin, size: size)
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
        
        pointSet = PointSet(rawPoints, gridDelta)
        
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
