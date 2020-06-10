//
//  MovingObjectView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 24.12.19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import MapKit

class MovingObjectView : MKAnnotationView {
    func onHeadingChanged(_ heading: CLLocationDirection) {
        UIView.animate(withDuration: 0.1, animations: { [unowned self] in
            self.transform = CGAffineTransform(rotationAngle: CGFloat(heading / 180 * .pi))
        })
    }
}
