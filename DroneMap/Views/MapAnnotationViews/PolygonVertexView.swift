//
//  PolygonVertexView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 24.12.19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import MapKit

protocol PolygonVertexViewDelegate : AnyObject {
    func vertexViewDragged(_ newPosition: CGPoint, _ id: Int)
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
