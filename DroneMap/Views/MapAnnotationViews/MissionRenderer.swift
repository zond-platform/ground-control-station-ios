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
    private var hull: ConvexHull = ConvexHull()
    private var grid: [CGPoint] = []

    // Observer properties
    var missionState: MissionState? {
        didSet {
            redrawRenderer()
        }
    }

    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        let polygon = self.overlay as? MissionPolygon
        if polygon != nil && missionState != nil {
            hull = polygon!.convexHull()
            grid = polygon!.missionGrid(for: hull, with: polygon!.gridDelta)
            switch missionState {
                case .editting:
                    drawPolygon(in: context)
                    drawVerticies(in: context, for: zoomScale)
                    drawGrid(in: context, for: zoomScale)
                default:
                    drawGrid(in: context, for: zoomScale)
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
}

// Private methods
extension MissionRenderer {
    private func drawPolygon(in context: CGContext) {
        let path = CGMutablePath()
        path.addLines(between: hull.points())
        path.addLine(to: hull.points().first!)
        context.addPath(path)
        context.setFillColor(red: 86.0, green: 167.0, blue: 20.0, alpha: 0.5)
        context.drawPath(using: .fill)
    }

    private func drawVerticies(in context: CGContext, for zoomScale: MKZoomScale) {
        for point in hull.points() {
            let radius = computeVertexRadius(for: zoomScale)
            let path = CGMutablePath()
            let circleOrigin = CGPoint(x: point.x - radius, y: point.y - radius)
            let circleSize = CGSize(width: radius * CGFloat(2.0), height: radius * CGFloat(2.0))
            path.addEllipse(in: CGRect.init(origin: circleOrigin, size: circleSize))
            context.addPath(path)
            context.setFillColor(red: 86.0, green: 167.0, blue: 20.0, alpha: 0.5)
            context.drawPath(using: .fill)
        }
    }

    private func drawGrid(in context: CGContext, for zoomScale: MKZoomScale) {
        let lineWidth = MKRoadWidthAtZoomScale(zoomScale) * 0.5
        let path = CGMutablePath()
        path.addLines(between: grid)
        context.setStrokeColor(UIColor.yellow.cgColor)
        context.setLineWidth(lineWidth)
        context.addPath(path)
        context.drawPath(using: .stroke)
    }

    private func computeVertexRadius(for zoomScale: MKZoomScale) -> CGFloat {
        var vertexRadius = zoomScaleToVertexRadiusMap[zoomScale]
        if vertexRadius == nil {
            vertexRadius = zoomScaleToVertexRadiusMap[0.125]
        }
        if let polygon = self.overlay as? MissionPolygon {
            polygon.vertexArea = vertexRadius!
        }
        return vertexRadius!
    }
}
