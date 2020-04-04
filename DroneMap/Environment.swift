//
//  Environment.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/19/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class Environment {
    enum ServiceType {
        case connection
        case simulator
        case battery
        case product
        case location
        case command
    }
    
    enum ViewControllerType {
        case root
        case status
        case map
        case control
        case console
        case selector
    }
    
    let logger: Logger = Logger()
    private var services: [ServiceType:ServiceProtocol] = [:]
    private var controllers: [ViewControllerType:UIViewController] = [:]
    
    init () {
        setupServices()
        setupControllers()
    }
}

// Public methods
extension Environment {
    func connectionService() -> ConnectionService {
        return services[.connection] as! ConnectionService
    }
    
    func simulatorService() -> SimulatorService {
        return services[.simulator] as! SimulatorService
    }
    
    func productService() -> ProductService {
        return services[.product] as! ProductService
    }
    
    func locationService() -> LocationService {
        return services[.location] as! LocationService
    }
    
    func batteryService() -> BatteryService {
        return services[.battery] as! BatteryService
    }
    
    func commandService() -> CommandService {
        return services[.command] as! CommandService
    }
    
    func rootViewController() -> RootViewController {
        return controllers[.root] as! RootViewController
    }
    
    func consoleViewController() -> ConsoleViewController {
        return controllers[.console] as! ConsoleViewController
    }
    
    func statusViewController() -> StatusViewController {
        return controllers[.status] as! StatusViewController
    }
    
    func mapViewController() -> MapViewController {
        return controllers[.map] as! MapViewController
    }
    
    func navigationViewConroller() -> ControlViewController {
        return controllers[.control] as! ControlViewController
    }

    func selectorViewConroller() -> SelectorViewController {
        return controllers[.selector] as! SelectorViewController
    }
}

// Private methods
extension Environment {
    private func setupServices() {
        services[.connection] = ConnectionService(self)
        services[.battery]    = BatteryService(self)
        services[.product]    = ProductService(self)
        services[.location]   = LocationService(self)
        services[.simulator]  = SimulatorService(self)
        services[.command]    = CommandService(self)
    }

    private func setupControllers() {
        controllers[.status]   = StatusViewController(self)
        controllers[.console]  = ConsoleViewController(self)
        controllers[.map]      = MapViewController(self)
        controllers[.control]  = ControlViewController(self)
        controllers[.selector] = SelectorViewController(self)

        // All the internal views and controllers should be already
        // created by the time root view controller is initialized.
        controllers[.root]     = RootViewController(self)
    }
}
