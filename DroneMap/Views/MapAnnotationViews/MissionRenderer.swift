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
    // Static properties
    static let vertexRadius: CGFloat = 100.0

    // Stored properties
    private var redrawTriggered = false
    var missionState: MissionState = .editting
    var hull: ConvexHull = ConvexHull()
    var grid: [CGPoint] = []

    // Observer properties
    var gridDelta: CGFloat = 10.0 {
        didSet {
            redrawRenderer()
        }
    }

    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        if let polygon = self.overlay as? MissionPolygon {
            hull = polygon.convexHull()
            grid = polygon.missionGrid(for: hull, with: gridDelta)

            let vertexRadius = computeVertexRadius(for: zoomScale)
            polygon.vertexArea = vertexRadius

            switch missionState {
                case .editting:
                    drawPolygon(in: context)
                    drawPolygonVerticies(in: context, with: vertexRadius)
                    drawGrid(in: context, lineWidth: MKRoadWidthAtZoomScale(zoomScale) * 0.5)
                default:
                    drawGrid(in: context, lineWidth: MKRoadWidthAtZoomScale(zoomScale) * 0.8)
            }
        }
    }
}

// Public methods
extension MissionRenderer {
    func redrawRenderer() {
        // The polygon renderer shall be redrawn every time the vertex position
        // changes. Though, the position change rate is way too fast for heavy
        // computations associated with the renderer update to keep up. As a result,
        // computationally expensive operations are queued which slows down the
        // entire application. Thus, limit the update rate to make redrawing smooth
        // and unnoticable to the user (as much as possible).
        if !redrawTriggered {
            redrawTriggered = true
            setNeedsDisplay()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.redrawTriggered = false
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

// Private methods
extension MissionRenderer {
    private func drawPolygon(in context: CGContext) {
        let polygonPath = CGMutablePath()
        polygonPath.addLines(between: hull.points())
        polygonPath.addLine(to: hull.points().first!)
        context.addPath(polygonPath)
        context.setFillColor(red: 86.0, green: 167.0, blue: 20.0, alpha: 0.5)
        context.drawPath(using: .fill)
    }

    private func drawGrid(in context: CGContext, lineWidth: CGFloat) {
        let gridPath = CGMutablePath()
        gridPath.addLines(between: grid)
        context.setStrokeColor(UIColor.yellow.cgColor)
        context.setLineWidth(lineWidth)
        context.addPath(gridPath)
        context.drawPath(using: .stroke)
    }

    private func drawPolygonVerticies(in context: CGContext, with radius: CGFloat) {
        for point in hull.points() {
            let vertexPath = CGMutablePath()
            let circleOrigin = CGPoint(x: point.x - radius, y: point.y - radius)
            let circleSize = CGSize(width: radius * CGFloat(2.0), height: radius * CGFloat(2.0))
            vertexPath.addEllipse(in: CGRect.init(origin: circleOrigin, size: circleSize))
            context.addPath(vertexPath)
            context.setFillColor(red: 86.0, green: 167.0, blue: 20.0, alpha: 0.5)
            context.drawPath(using: .fill)
        }
    }

    private func computeVertexRadius(for zoomScale: MKZoomScale) -> CGFloat {
        var vertexRadius = zoomScaleToVertexRadiusMap[zoomScale]
        if vertexRadius == nil {
            vertexRadius = zoomScaleToVertexRadiusMap[0.125]
        }
        return vertexRadius!
    }
}
