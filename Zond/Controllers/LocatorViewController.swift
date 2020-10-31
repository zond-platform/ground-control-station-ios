//
//  ControlViewController.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 14.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

import DJISDK

class LocatorViewController : UIViewController {
    private var locatorView: LocatorView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        locatorView = LocatorView()
        registerListeners()
        view = locatorView
    }
}

// Private methods
extension LocatorViewController {
    private func registerListeners() {
        locatorView.buttonPressed = { id in
            switch id {
                case .focus:
                    let trackSuccess = Environment.mapViewController.trackUser(true)
                    let newId = trackSuccess ? LocatorButtonId.user : LocatorButtonId.focus
                    self.locatorView.setLocateObjectButtonId(newId)
                case .user:
                    let trackSuccess = Environment.mapViewController.trackAircraft(true)
                    let newId = trackSuccess ? LocatorButtonId.aircraft : LocatorButtonId.focus
                    self.locatorView.setLocateObjectButtonId(newId)
                case .aircraft:
                    let _ = Environment.mapViewController.trackAircraft(false)
                    self.locatorView.setLocateObjectButtonId(.focus)
                case .home:
                    let _ = Environment.mapViewController.trackUser(false)
                    let _ = Environment.mapViewController.trackAircraft(false)
                    self.locatorView.setLocateObjectButtonId(.focus)
                    Environment.mapViewController.locateHome()
            }
        }
        Environment.locationService.aircraftLocationListeners.append({ location in
            if location == nil {
                self.locatorView.setLocateObjectButtonId(.focus)
            }
        })
        Environment.missionStateManager.stateListeners.append({ _, newState in
            if newState != nil && newState! == .editing {
                self.toggleShowFromSideAnimated(show: false, delay: 0)
            } else {
                self.toggleShowFromSideAnimated(show: true, delay: Animations.defaultDelay)
            }
        })
    }

    private func toggleShowFromSideAnimated(show: Bool, delay: TimeInterval) {
        UIView.animate(
            withDuration: Animations.defaultDuration,
            delay: delay,
            options: [],
            animations: {
                self.locatorView.toggleShowFromSide(show)
            }
        )
    }
}
