//
//  Environment.swift
//  Aeroglaz
//
//  Created by Evgeny Agamirzov on 17.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

struct Environment {
    // Shared services
    static let connectionService = ConnectionService()
    static let simulatorService  = SimulatorService()
    static let commandService    = CommandService()
    static let locationService   = LocationService()
    static let telemetryService  = TelemetryService()

    // Shared controllers
    static let mapViewController        = MapViewController()
    static let consoleViewController    = ConsoleViewController()
    static let missionViewController    = MissionViewController()
    static let navigationViewController = NavigationViewController()
    static let statusViewController     = StatusViewController()
    static let rootViewController       = RootViewController()
}
