//
//  MissionRenderer.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 24.12.19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import MapKit

fileprivate let zoomScaleToVertexRadiusMap: [MKZoomScale:CGFloat] = [
    1.0     : MissionRenderer.vertexRadius * CGFloat(1.5),
    0.5     : MissionRenderer.vertexRadius * CGFloat(2.0),
    0.25    : MissionRenderer.vertexRadius * CGFloat(2.5),
    0.125   : MissionRenderer.vertexRadius * CGFloat(3.0),
    0.0625  : MissionRenderer.vertexRadius * CGFloat(3.5),
    0.03125 : MissionRenderer.vertexRadius * CGFloat(4.0),
]

fileprivate let zoomScaleToWaypointRadiusMap: [MKZoomScale:CGFloat] = [
    1.0   : MissionRenderer.waypointRadius,
    0.5   : MissionRenderer.waypointRadius * CGFloat(1.2),
    0.25  : MissionRenderer.waypointRadius * CGFloat(1.4),
    0.125 : MissionRenderer.waypointRadius * CGFloat(1.6),
]

class MissionRenderer : MKOverlayRenderer {
    // Static properties
    static let vertexRadius: CGFloat = 10.0
    static let waypointRadius: CGFloat = 20.0

    // Stored properties
    private var pointSet = PointSet()
    private var redrawTriggered = false
    private var lastAircraftPoint: CGPoint?
    private var context: CGContext?
    private var zoomScale: MKZoomScale?

    // Computed properties
    var pixelsPerMeter: CGFloat {
        let minY = pointSet.points.min{ left, right in left.y < right.y }!.y
        let maxY = pointSet.points.max{ left, right in left.y < right.y }!.y
        let minPoint = CGPoint(x: 0, y: minY)
        let maxPoint = CGPoint(x: 0, y: maxY)
        let minMapPoint = MKMapPoint(x: 0, y: self.mapPoint(for: minPoint).y)
        let maxMapPoint = MKMapPoint(x: 0, y: self.mapPoint(for: maxPoint).y)
        let pixelHeight = abs(maxY - minY)
        let meterHeight = CGFloat(minMapPoint.distance(to: maxMapPoint))
        return pixelHeight / meterHeight
    }
    var canDraw: Bool {
        return context != nil && zoomScale != nil && pointSet.isComputed
    }
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
        if polygon != nil {
            return pixelsPerMeter * polygon!.gridDistance
        } else {
            return 0.0
        }
    }
    var liveGridTangent: CGFloat? {
        let polygon = self.overlay as? MissionPolygon
        if polygon != nil {
            let angle = polygon!.gridAngle * (CGFloat.pi / 180)
            if angle != 0 && angle.remainder(dividingBy: CGFloat.pi / 2) == 0 {
                return nil
            } else {
                // Inverse tangent so that inclination is correct in the flipped coordinate system
                return -tan(angle)
            }
        } else {
            return 0.0
        }
    }

    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        let polygon = self.overlay as? MissionPolygon
        if polygon != nil && polygon!.missionState != nil {
            self.context = context
            self.zoomScale = zoomScale
            computeGeometries(from: polygon!.coordinates)
            if canDraw {
                let state = polygon!.missionState!

                // Draw only for editing state
                if state == .editing {
                    drawVertices()
                }

                // Draw for all states
                drawHull()
                drawMeander()
                drawAircraftLine(state == .running || state == .paused
                                 ? lastAircraftPoint
                                 : liveAircraftPoint)
            }
        }
    }
}

// Public methods
extension MissionRenderer {
    func redrawRenderer() {
        // The refresh rate is way too fast for heavy computations associated
        // with the renderer update to keep up. As a result, computationally
        // expensive operations are queued which slows down the entire application.
        // Thus, limit the update rate to make redrawing smooth (as much as possible).
        if !redrawTriggered {
            redrawTriggered = true
            setNeedsDisplay()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.redrawTriggered = false
            }
        }
    }

    func missionCoordinates() -> [CLLocationCoordinate2D] {
        var coordnates: [CLLocationCoordinate2D] = []
        for point in pointSet.meander.points {
            coordnates.append(mapPoint(for: point).coordinate)
        }
        return coordnates
    }
}

// Private utility methods
extension MissionRenderer {
    private func computeGeometries(from coordinates: [CLLocationCoordinate2D]) {
        var points: [CGPoint] = []
        for coordinate in coordinates {
            points.append(point(for: MKMapPoint(coordinate)))
        }
        pointSet.set(points: points)
        pointSet.computeHull()
        pointSet.computeMeander(liveGridDelta, liveGridTangent)
    }

    private func computeRadius(for map: [MKZoomScale:CGFloat], with zoomScale: MKZoomScale) -> CGFloat {
        var vertexRadius = map[zoomScale]
        if vertexRadius == nil {
            vertexRadius = map.keys.max{ $0 < $1 }
        }
        return vertexRadius!
    }
}

// Private drawing methods
extension MissionRenderer {
    private func drawHull() {
        let path = CGMutablePath()
        path.addLines(between: pointSet.hull.points)
        path.addLine(to: pointSet.hull.points.first!)
        context!.addPath(path)
        context!.setFillColor(red: 86.0, green: 167.0, blue: 20.0, alpha: 0.5)
        context!.drawPath(using: .fill)
    }

    private func drawVertices() {
        for point in pointSet.points {
            let meterRadius = computeRadius(for: zoomScaleToVertexRadiusMap, with: zoomScale!)
            (self.overlay as? MissionPolygon)?.vertexRadius = Double(meterRadius)
            let path = CGMutablePath()
            let pixelRadius = meterRadius * pixelsPerMeter
            let circleOrigin = CGPoint(x: point.x - pixelRadius, y: point.y - pixelRadius)
            let circleSize = CGSize(width: pixelRadius * CGFloat(2.0), height: pixelRadius * CGFloat(2.0))
            path.addEllipse(in: CGRect.init(origin: circleOrigin, size: circleSize))
            context!.addPath(path)
            context!.setFillColor(red: 86.0, green: 167.0, blue: 20.0, alpha: 0.5)
            context!.drawPath(using: .fill)
        }
    }

    private func drawMeander() {
        // Meander
        let lineWidth = MKRoadWidthAtZoomScale(zoomScale!) * 0.5
        let meanderPath = CGMutablePath()
        meanderPath.addLines(between: pointSet.meander.points)
        context!.setStrokeColor(UIColor.yellow.cgColor)
        context!.setLineWidth(lineWidth)
        context!.addPath(meanderPath)
        context!.drawPath(using: .stroke)

        // Start and finish points
        let pointsPath = CGMutablePath()
        let radius = computeRadius(for: zoomScaleToWaypointRadiusMap, with: zoomScale!)
        let size = CGSize(width: radius * CGFloat(2.0), height: radius * CGFloat(2.0))
        let startOrigin = CGPoint(x: pointSet.meander.points.first!.x - radius, y: pointSet.meander.points.first!.y - radius)
        pointsPath.addEllipse(in: CGRect.init(origin: startOrigin, size: size))
        let finishOrigin = CGPoint(x: pointSet.meander.points.last!.x - radius, y: pointSet.meander.points.last!.y - radius)
        pointsPath.addEllipse(in: CGRect.init(origin: finishOrigin, size: size))
        context!.setFillColor(UIColor.yellow.cgColor)
        context!.addPath(pointsPath)
        context!.drawPath(using: .fill)
    }

    private func drawAircraftLine(_ aircraftLocation: CGPoint?) {
        if let aircraftLocation = aircraftLocation {
            let lineWidth = MKRoadWidthAtZoomScale(zoomScale!) * 0.5
            let path = CGMutablePath()
            let radius = computeRadius(for: zoomScaleToWaypointRadiusMap, with: zoomScale!)
            let size = CGSize(width: radius * CGFloat(2.0), height: radius * CGFloat(2.0))
            let startOrigin = CGPoint(x: aircraftLocation.x - radius, y: aircraftLocation.y - radius)
            path.addEllipse(in: CGRect.init(origin: startOrigin, size: size))
            path.move(to: aircraftLocation)
            path.addLine(to: pointSet.meander.points.first!)
            context!.setStrokeColor(UIColor.yellow.cgColor)
            context!.setLineWidth(lineWidth)
            context!.setLineDash(phase: 0.0, lengths: [40, 40])
            context!.addPath(path)
            context!.drawPath(using: .stroke)
        }
    }
}
