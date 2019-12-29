//
//  MissionRenderer.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 24.12.19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import MapKit

class MissionRenderer : MKOverlayRenderer {
    private var vertexPositionChangeFired = false
    private var delta: CGFloat = 0.0

    init(_ overlay: MKOverlay, _ delta: CGFloat) {
        self.delta = delta
        super.init(overlay: overlay)
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

// Handle updates of the polygon overlay
extension MissionRenderer : MissionPolygonDelegate {
    func redrawRenderer() {
        // The polygon renderer shall be redrawn every time the vertex position
        // changes. Though, the position change rate is way too fast for heavy
        // computations associated with the renderer update to keep up. As a result,
        // computationally expensive operations are queued which slows down the
        // entire application. Thus, limit the update rate to make redrawing smooth
        // and unnoticable to the user (as much as possible).
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
}
