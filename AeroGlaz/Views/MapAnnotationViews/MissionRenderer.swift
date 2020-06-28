//
//  MissionRenderer.swift
//  Aeroglaz
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

fileprivate let zoomScaleToWaypointRadiusMap: [MKZoomScale:CGFloat] = [
    1.0   : MissionRenderer.waypointRadius,
    0.5   : MissionRenderer.waypointRadius * CGFloat(1.2),
    0.25  : MissionRenderer.waypointRadius * CGFloat(1.4),
    0.125 : MissionRenderer.waypointRadius * CGFloat(1.6),
]

class MissionRenderer : MKOverlayRenderer {
    // Static properties
    static let vertexRadius: CGFloat = 100.0
    static let waypointRadius: CGFloat = 20.0

    // Stored properties
    private var redrawTriggered = false
    private var hull: [CGPoint] = []
    private var grid: [CGPoint] = []
    private var lastAircraftPoint: CGPoint?

    // Computed properties
    var liveAircraftPoint: CGPoint? {
        let polygon = self.overlay as? MissionPolygon
        var point: CGPoint?
        if polygon != nil && polygon!.aircraftLocation != nil {
            point = self.point(for: MKMapPoint(polygon!.aircraftLocation!.coordinate))
        } else {
            point = nil
        }
        lastAircraftPoint = point
        return point
    }
    var liveGridDelta: CGFloat {
        let polygon = self.overlay as? MissionPolygon
        if polygon!.gridDistance != nil {
            let lowermostPoint = polygon!.rawPoints.lowermost()
            let uppermostPoint = polygon!.rawPoints.uppermost()
            let lowermostMapPoint = MKMapPoint(x: 0.0, y: self.mapPoint(for: lowermostPoint).y)
            let uppermostMapPoint = MKMapPoint(x: 0.0, y: self.mapPoint(for: uppermostPoint).y)
            let numLines = CGFloat(lowermostMapPoint.distance(to: uppermostMapPoint)) / polygon!.gridDistance!
            return (uppermostPoint.y - lowermostPoint.y) / numLines
        } else {
            return 0.0
        }
    }

    // Observer properties
    var missionState: MissionState? {
        didSet {
            redrawRenderer()
        }
    }

    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        let polygon = self.overlay as? MissionPolygon
        if polygon != nil && missionState != nil {
            polygon!.rawPoints.recomputeShapes(liveGridDelta, 2.0)
            hull = polygon!.rawPoints.convexHull()
            grid = polygon!.rawPoints.meanderGrid()
            switch missionState {
                case .editing:
                    drawPolygon(in: context)
                    drawVerticies(in: context, for: zoomScale)
                    drawGrid(in: context, for: zoomScale)
                    drawWaypoints(in: context, for: zoomScale)
                    drawAircraftLine(in: context, for: zoomScale, and: liveAircraftPoint)
                case .uploaded:
                    drawGrid(in: context, for: zoomScale)
                    drawWaypoints(in: context, for: zoomScale)
                    drawAircraftLine(in: context, for: zoomScale, and: liveAircraftPoint)
                default:
                    drawGrid(in: context, for: zoomScale)
                    drawWaypoints(in: context, for: zoomScale)
                    drawAircraftLine(in: context, for: zoomScale, and: lastAircraftPoint)
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
        if !hull.isEmpty {
            let path = CGMutablePath()
            path.addLines(between: hull)
            path.addLine(to: hull.first!)
            context.addPath(path)
            context.setFillColor(red: 86.0, green: 167.0, blue: 20.0, alpha: 0.5)
            context.drawPath(using: .fill)
        }
    }

    private func drawVerticies(in context: CGContext, for zoomScale: MKZoomScale) {
        for point in hull {
            let radius = computeRadius(for: zoomScaleToVertexRadiusMap, with: zoomScale)
            if let polygon = self.overlay as? MissionPolygon {
                // Change active touch area
                polygon.vertexArea = radius
            }
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
        if !grid.isEmpty {
            let lineWidth = MKRoadWidthAtZoomScale(zoomScale) * 0.5
            let path = CGMutablePath()
            path.addLines(between: grid)
            context.setStrokeColor(UIColor.yellow.cgColor)
            context.setLineWidth(lineWidth)
            context.addPath(path)
            context.drawPath(using: .stroke)
        }
    }

    private func drawWaypoints(in context: CGContext, for zoomScale: MKZoomScale) {
        if !grid.isEmpty {
            let path = CGMutablePath()
            let radius = computeRadius(for: zoomScaleToWaypointRadiusMap, with: zoomScale)
            let size = CGSize(width: radius * CGFloat(2.0), height: radius * CGFloat(2.0))
            let startOrigin = CGPoint(x: grid.first!.x - radius, y: grid.first!.y - radius)
            path.addEllipse(in: CGRect.init(origin: startOrigin, size: size))
            let finishOrigin = CGPoint(x: grid.last!.x - radius, y: grid.last!.y - radius)
            path.addEllipse(in: CGRect.init(origin: finishOrigin, size: size))
            context.setFillColor(UIColor.yellow.cgColor)
            context.addPath(path)
            context.drawPath(using: .fill)
        }
    }

    private func drawAircraftLine(in context: CGContext, for zoomScale: MKZoomScale, and location: CGPoint?) {
        if let aircraftLocation = location {
            if !grid.isEmpty {
                let lineWidth = MKRoadWidthAtZoomScale(zoomScale) * 0.5
                let path = CGMutablePath()
                path.move(to: aircraftLocation)
                path.addLine(to: grid.first!)
                context.setStrokeColor(UIColor.yellow.cgColor)
                context.setLineWidth(lineWidth)
                context.setLineDash(phase: 0.0, lengths: [40, 40])
                context.addPath(path)
                context.drawPath(using: .stroke)
            }
        }
    }

    private func computeRadius(for map: [MKZoomScale:CGFloat], with zoomScale: MKZoomScale) -> CGFloat {
        var vertexRadius = map[zoomScale]
        if vertexRadius == nil {
            vertexRadius = map[0.125]
        }
        return vertexRadius!
    }
}
