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
        case status
        case console
        case map
        case root
        case navigation
    }
    
    let logger: Logger = Logger()
    private var services: [ServiceType:ServiceProtocol] = [:]
    private var viewControllers: [ViewControllerType:UIViewController] = [:]
    
    init () {
        setupServices()
        setupViewControllers()
    }
    
// Initialization
/*************************************************************************************************/
    private func setupServices() {
        services[.connection] = ConnectionService(self)
        services[.battery]    = BatteryService(self)
        services[.product]    = ProductService(self)
        services[.location]   = LocationService(self)
        services[.simulator]  = SimulatorService(self)
        services[.command]    = CommandService(self)
    }
    
    private func setupViewControllers() {
        viewControllers[.status]     = StatusViewController(self)
        viewControllers[.console]    = ConsoleViewController(self)
        viewControllers[.map]        = MapViewController(self)
        viewControllers[.navigation] = NavigationViewController(self)
        viewControllers[.root]       = RootViewController(self)
    }

// Service getters
/*************************************************************************************************/
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
    
// Controller getters
/*************************************************************************************************/
    func rootViewController() -> RootViewController {
        return viewControllers[.root] as! RootViewController
    }
    
    func consoleViewController() -> ConsoleViewController {
        return viewControllers[.console] as! ConsoleViewController
    }
    
    func statusViewController() -> StatusViewController {
        return viewControllers[.status] as! StatusViewController
    }
    
    func mapViewController() -> MapViewController {
        return viewControllers[.map] as! MapViewController
    }
    
    func navigationViewConroller() -> NavigationViewController {
        return viewControllers[.navigation] as! NavigationViewController
    }
}
