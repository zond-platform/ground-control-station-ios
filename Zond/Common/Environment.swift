//
//  Environment.swift
//  Zond
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
    static let mapViewController              = MapViewController()
    static let statusViewController           = StatusViewController()
    static let consoleViewController          = ConsoleViewController()
    static let staticTelemetryViewController  = StaticTelemetryViewController()
    static let dynamicTelemetryViewController = DynamicTelemetryViewController()
    static let missionViewController          = MissionViewController()
    static let parametersViewController       = ParametersViewController()
    static let importExportViewController     = ImportExportViewController()
    static let commandViewController          = CommandViewController()
    static let locatorViewController          = LocatorViewController()
    static let rootViewController             = RootViewController()

    // Shared mission objects
    static let missionStateManager = MissionStateManager()
    static let missionParameters   = MissionParameters()
    static let missionStorage      = MissionStorage()
}
