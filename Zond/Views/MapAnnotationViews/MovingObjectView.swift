//
//  MovingObjectView.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 24.12.19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import MapKit

fileprivate let iconOrientationOffset = -45.0
fileprivate let deviceOrientationOffset = UIDevice.current.orientation == .landscapeLeft ? 90.0 : -90.0

class MovingObjectView : MKAnnotationView {
    private var headingOffset: CLLocationDirection {
        if let movingObject = annotation as? MovingObject {
            switch movingObject.type {
                case .aircraft:
                    return iconOrientationOffset
                case .user:
                    return iconOrientationOffset + deviceOrientationOffset
                default:
                    return 0.0
            }
        } else {
            return 0.0
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
}

// Public methods
extension MovingObjectView {
    func addedToMapView() {
        rotate(to: headingOffset)
    }

    func onHeadingChanged(_ heading: CLLocationDirection) {
        UIView.animate(withDuration: 0.1, animations: {
            self.rotate(to: heading + self.headingOffset)
        })
    }
}

// Private methods
extension MovingObjectView {
    func rotate(to heading: CLLocationDirection) {
        self.transform = CGAffineTransform(rotationAngle: CGFloat((heading) / 180 * .pi))
    }
}
