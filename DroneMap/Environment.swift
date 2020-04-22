//
//  Environment.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 17.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

struct Environment {
    // Shared services
    static let connectionService = ConnectionService()
    static let batteryService    = BatteryService()
    static let productService    = ProductService()
    static let locationService   = LocationService()
    static let simulatorService  = SimulatorService()
    static let commandService    = CommandService()

    // Shared view controllers
    static let mapViewController      = MapViewController()
    static let tabViewController      = TabViewController()
    static let settingsViewController = SettingsViewController()
    static let controlViewController  = ControlViewController()
    static let rootViewController     = RootViewController()
}
