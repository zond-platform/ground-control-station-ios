//
//  NavigationBarController.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 5/3/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit
import DJISDK

/*************************************************************************************************/
class NavigationViewController : UIViewController {
    private var env: Environment!
    private var navigationView: NavigationView!
    private var simulatorLocation = CLLocationCoordinate2DMake(48.13, 11.58)

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ env: Environment) {
        super.init(nibName: nil, bundle: nil)
        self.env = env
        
        env.simulatorService().addDelegate(self)
        env.connectionService().addDelegate(self)
        env.productService().addDelegate(self)
        
        navigationView = NavigationView()
        navigationView.delegate = self
        view = navigationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

/*************************************************************************************************/
extension NavigationViewController : NavigationViewDelegate {
    func restartButtonPressed() {
        env.connectionService().restart()
    }
    
    func consoleButtonSelected(_ selected: Bool) {
        env.rootViewController().showTabView(selected)
    }
    
    func simulatorButtonSelected(_ selected: Bool) {
        if selected {
            if let userLocation = env.mapViewController().userLocation() {
                simulatorLocation = userLocation
            } else {
                env.logger.logDebug("Using default simulator location", .navigation)
            }
            env.simulatorService().startSimulator(simulatorLocation)
        } else {
            env.simulatorService().stopSimulator()
        }
    }
    
    func takeOffRequested() {
        env.commandService().doAction(.takeoff)
    }
    
    func landingRequested() {
        env.commandService().doAction(.land)
    }
}

/*************************************************************************************************/
extension NavigationViewController : ProductServiceDelegate {
    func modelChanged(_ model: String) {
        if model == DJIAircraftModeNameOnlyRemoteController {
            navigationView.onSimulatorResponse(false)
        }
    }
}

/*************************************************************************************************/
extension NavigationViewController : ConnectionServiceDelegate {
    func statusChanged(_ status: ConnectionStatus) {
        if status == .disconnected {
            navigationView.onSimulatorResponse(false)
        } else {
            navigationView.onConnectionEstablished()
        }
    }
}

/*************************************************************************************************/
extension NavigationViewController : SimulatorServiceDelegate {
    func commandResponded(_ success: Bool) {
        navigationView.onSimulatorResponse(success)
    }
}
