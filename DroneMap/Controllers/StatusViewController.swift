//
//  StatusViewController.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 5/25/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class StatusViewController : UIViewController {
    var statusView: StatusView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ env: Environment) {
        super.init(nibName: nil, bundle: nil)
        env.batteryService().addDelegate(self)
        env.locationService().addDelegate(self)
        statusView = StatusView()
        view = statusView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// Handle battery status updates
extension StatusViewController : BatteryServiceDelegate {
    func batteryChargeChanged(_ charge: UInt) {
        statusView.updateValue(.battery, String(charge) + "%")
    }
}

// Handle location updates
extension StatusViewController : LocationServiceDelegate {
    func signalStatusChanged(_ status: String) {
        statusView.updateValue(.gps, status)
    }
    
    func satelliteCountChanged(_ count: UInt) {
        statusView.updateValue(.satellites, String(count))
    }
    
    func altitudeChanged(_ altitude: Double) {
        statusView.updateValue(.altitude, String(altitude))
    }
    
    func flightModeChanged(_ mode: String) {
        statusView.updateValue(.mode, mode)
    }
}
