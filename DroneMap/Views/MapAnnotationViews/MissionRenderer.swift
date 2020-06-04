//
//  MissionRenderer.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 24.12.19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import MapKit

fileprivate let zoomScaleToVertexRadiusMap: [MKZoomScale:CGFloat] = [
    1.0   : MissionRenderer.vertexRadius,
    0.5   : MissionRenderer.vertexRadius * CGFloat(1.5),
    0.25  : MissionRenderer.vertexRadius * CGFloat(2.0),
    0.125 : MissionRenderer.vertexRadius * CGFloat(2.5),
]

class MissionRenderer : MKOverlayRenderer {
    static let vertexRadius: CGFloat = 100.0
    private var vertexPositionChangeFired = false
    var gridDistance: CGFloat = 20.0

    init(_ overlay: MKOverlay, _ gridDistance: CGFloat) {
        super.init(overlay: overlay)
        self.gridDistance = gridDistance
    }

    override func draw(_ : MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        if let polygon = self.overlay as? MissionPolygon {
            let hull = polygon.convexHull()
            let grid = polygon.missionGrid(for: hull, with: polygon.verticalDistance() / gridDistance)

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

            var vertexRadius = zoomScaleToVertexRadiusMap[zoomScale]
            if vertexRadius == nil {
                vertexRadius = zoomScaleToVertexRadiusMap[0.125]
            }
            polygon.vertexArea = vertexRadius!
            for point in hull.points() {
                let vertexPath = CGMutablePath()
                let circleOrigin = CGPoint(x: point.x - vertexRadius!, y: point.y - vertexRadius!)
                let circleSize = CGSize(width: vertexRadius! * CGFloat(2.0), height: vertexRadius! * CGFloat(2.0))
                vertexPath.addEllipse(in: CGRect.init(origin: circleOrigin, size: circleSize))
                context.addPath(vertexPath)
                context.setFillColor(red: 86.0, green: 167.0, blue: 20.0, alpha: 0.5)
                context.drawPath(using: .fill)
            }
        }
    }
}

// Handle updates of the polygon overlay
extension MissionRenderer : MissionPolygonDelegate {
    internal func redrawRenderer() {
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
    
    internal func setGridDistance(_ distance: CGFloat) {
        gridDistance = distance
        redrawRenderer()
    }

    internal func translateMapPoint(_ mapPoint: MKMapPoint) -> CGPoint {
        return point(for: mapPoint)
    }
    
    internal func translateRawPoint(_ rawPoint: CGPoint) -> MKMapPoint {
        return mapPoint(for: rawPoint)
    }
}
