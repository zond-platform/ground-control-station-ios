//
//  ControlViewController.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 14.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

import DJISDK

class NavigationViewController : UIViewController {
    private var navigationView: NavigationView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        navigationView = NavigationView()
        registerCallbacks()
        Environment.productService.addDelegate(self)
        view = navigationView
    }
}

// Private methods
extension NavigationViewController {
    func registerCallbacks() {
        navigationView.buttonSelected = { id, isSelected in
            switch id {
                case .simulator:
                    if isSelected {
                        let userLocation = Environment.mapViewController.userLocation
                        Environment.simulatorService.startSimulator(userLocation, { success in
                            if !success {
                                self.navigationView.deselectButton(with: .simulator)
                            }
                        })
                    } else {
                        Environment.simulatorService.stopSimulator({ success in
                            if success {
                                self.navigationView.deselectButton(with: .simulator)
                            }
                        })
                    }
                case .user:
                    if Environment.mapViewController.trackUser(isSelected) {
                        self.navigationView.deselectButton(with: .aircraft)
                    } else {
                        self.navigationView.deselectButton(with: .user)
                    }
                case .aircraft:
                    if Environment.mapViewController.trackAircraft(isSelected) {
                        self.navigationView.deselectButton(with: .user)
                    } else {
                        self.navigationView.deselectButton(with: .aircraft)
                    }
            }
        }
    }
}

// Subscribe to connected product updates
extension NavigationViewController : ProductServiceDelegate {
    internal func modelChanged(_ model: String?) {
        if model == nil || model == DJIAircraftModeNameOnlyRemoteController {
            self.navigationView.deselectButton(with: .simulator)
        }
    }
}
