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
    func registerListeners() {
        locatorView.buttonSelected = { id, isSelected in
            switch id {
                case .user:
                    if Environment.mapViewController.trackUser(isSelected) {
                        self.locatorView.deselectButton(with: .aircraft)
                    } else {
                        self.locatorView.deselectButton(with: .user)
                    }
                case .aircraft:
                    if Environment.mapViewController.trackAircraft(isSelected) {
                        self.locatorView.deselectButton(with: .user)
                    } else {
                        self.locatorView.deselectButton(with: .aircraft)
                    }
            }
        }
        Environment.locationService.aircraftLocationListeners.append({ location in
            if location == nil {
                self.locatorView.deselectButton(with: .aircraft)
            }
        })
    }
}
