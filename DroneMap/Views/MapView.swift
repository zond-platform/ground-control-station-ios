//
//  MapView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/27/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit
import MapKit

protocol PolygonVertexViewDelegate : AnyObject {
    func vertexViewDragged(_ newPosition: CGPoint, _ id: Int)
}

class MovingObjectView : MKAnnotationView, MovingObjectDelegate {
    func objectHeadingChanged(_ heading: CLLocationDirection) {
        UIView.animate(withDuration: 0.1, animations: { [unowned self] in
            self.transform = CGAffineTransform(rotationAngle: CGFloat(heading / 180 * .pi))
        })
    }
}

class PolygonVertexView : MKAnnotationView {
    weak var delegate: PolygonVertexViewDelegate?
    override var center: CGPoint {
        didSet {
            guard let annotation = self.annotation as? PolygonVertex else {
                return
            }
            guard self.dragState == .dragging else {
                return
            }
            delegate?.vertexViewDragged(center, annotation.id)
        }
    }
}

class MissionRenderer : MKOverlayRenderer, MissionPolygonDelegate {
    private var vertexPositionChangeFired = false
    private var delta: CGFloat = 0.0

    init(_ overlay: MKOverlay, _ delta: CGFloat) {
        self.delta = delta
        super.init(overlay: overlay)
    }

    func redrawRenderer() {
        // The polygon renderer shall be redrawn every time the vertex position
        // changes. Though, the position change rate is way too fast for heavy
        // computations associated with the renderer update to keep up. As a result,
        // computationally expensive operations are queued which slows down the
        // entire application. Thus, limit the update rate to make redrawing smooth
        // and unnoticable to the user.
        if !vertexPositionChangeFired {
            vertexPositionChangeFired = true
            setNeedsDisplay()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.vertexPositionChangeFired = false
            }
        }
    }
    
    func translateMapPoint(_ mapPoint: MKMapPoint) -> CGPoint {
        return point(for: mapPoint)
    }
    
    func translateRawPoint(_ rawPoint: CGPoint) -> MKMapPoint {
        return mapPoint(for: rawPoint)
    }

    override func draw(_ : MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        if let polygon = self.overlay as? MissionPolygon {
            let hull = polygon.convexHull()
            let grid = polygon.missionGrid(for: hull, with: delta)
            
            let polygonPath = CGMutablePath()
            polygonPath.addLines(between: hull.points())
            polygonPath.addLine(to: hull.points().first!)
            context.addPath(polygonPath)
            context.setFillColor(red: 86.0, green: 167.0, blue: 20.0, alpha: 0.5)
            context.drawPath(using: .fill)
            
            let gridPath = CGMutablePath()
            gridPath.addLines(between: grid)
            context.setStrokeColor(UIColor.yellow.cgColor)
            context.setLineWidth(MKRoadWidthAtZoomScale(zoomScale) * 0.5)
            context.addPath(gridPath)
            context.drawPath(using: .stroke)
        }
    }
}

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
