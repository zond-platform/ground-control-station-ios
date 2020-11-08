//
//  DynamicTelemetryViewController.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 28.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import CoreLocation
import UIKit

class DynamicTelemetryViewController : UIViewController {
    private var dynamicTelemetryView: DynamicTelemetryView!
    private var lastHomeLocation: CLLocation?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        dynamicTelemetryView = DynamicTelemetryView()
        registerListeners()
        view = dynamicTelemetryView
    }
}

// Private methods
extension DynamicTelemetryViewController {
    private func registerListeners() {
        Environment.telemetryService.horizontalVelocityChanged = { horizontalVelocity in
            let value = horizontalVelocity != nil ? String(format: "%.1f", horizontalVelocity!) : nil
            self.dynamicTelemetryView.updateTelemetryValue(.horizontalSpeed, with: value)
        }
        Environment.telemetryService.verticalVelocityChanged = { verticalVelocity in
            let value = verticalVelocity != nil ? String(format: "%.1f", verticalVelocity!) : nil
            self.dynamicTelemetryView.updateTelemetryValue(.verticalSpeed, with: value)
        }
        Environment.telemetryService.altitudeChanged = { altitude in
            let value = altitude != nil ? String(altitude!) : nil
            self.dynamicTelemetryView.updateTelemetryValue(.altitude, with: value)
        }
        Environment.locationService.aircraftLocationListeners.append({ location in
            if location != nil && self.lastHomeLocation != nil {
                let value = location!.distance(from: self.lastHomeLocation!)
                self.dynamicTelemetryView.updateTelemetryValue(.distance, with: String(format: "%.0f", value))
            }
        })
        Environment.locationService.homeLocationListeners.append({ location in
            self.lastHomeLocation = location
        })
        Environment.missionStateManager.stateListeners.append({ newState in
            if newState == .editing {
                self.toggleShowFromBottomAnimated(show: false, delay: 0)
            } else {
                self.toggleShowFromBottomAnimated(show: true, delay: Animations.defaultDelay)
            }
        })
    }

    private func toggleShowFromBottomAnimated(show: Bool, delay: TimeInterval) {
        if show {
            self.dynamicTelemetryView.isHidden = false
        }
        UIView.animate(
            withDuration: Animations.defaultDuration,
            delay: delay,
            options: [],
            animations: {
                self.dynamicTelemetryView.toggleShowFromBottom(show)
            },
            completion: { _ in
                if !show {
                    self.dynamicTelemetryView.isHidden = true
                }
            }
        )
    }
}
