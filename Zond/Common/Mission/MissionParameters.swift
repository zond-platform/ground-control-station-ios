//
//  MissionParameters.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 17.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

enum MissionParameterId {
    case meanderStep
    case meanderAngle
    case altitude
    case speed

    var name: String {
        switch self {
            case .meanderStep:
                return "Meander"
            case .meanderAngle:
                return "Angle"
            case .altitude:
                return "Altitude"
            case .speed:
                return "Speed"
        }
    }

    var unit: String {
        switch self {
            case .meanderStep:
                return "m"
            case .meanderAngle:
                return "°"
            case .altitude:
                return "m"
            case .speed:
                return "m/s"
        }
    }

    var defaultValue: Float {
        switch self {
            case .meanderStep:
                return 20
            case .meanderAngle:
                return 0
            case .altitude:
                return 100
            case .speed:
                return 10
        }
    }
}

extension MissionParameterId : CaseIterable {}

struct MissionParameterRange {
    let min: Float
    let max: Float
    let step: Float
    let defaultValue: Float

    init(min: Float, max: Float, step: Float, defaultValue: Float) {
        self.min = min
        self.max = max
        self.step = step
        self.defaultValue = defaultValue
        assert(self.contains(defaultValue))
        assert((max - min).truncatingRemainder(dividingBy: step) == 0)
    }

    internal func contains(_ value: Float) -> Bool {
        return value >= min && value <= max
    }
}

class MissionParameter {
    // Stored properties
    let range: MissionParameterRange

    // Observer properties
    var value: Float {
        didSet {
            for listener in valueListeners {
                listener?(value)
            }
        }
    }

    // Notifyer properties
    var valueListeners: [((_ value: Float) -> Void)?] = []

    init(_ id: MissionParameterId) {
        switch id {
            case .meanderStep:
                self.range = MissionParameterRange(min: 5, max: 50, step: 1, defaultValue: id.defaultValue)
            case .meanderAngle:
                self.range = MissionParameterRange(min: -90, max: 90, step: 1, defaultValue: id.defaultValue)
            case .altitude:
                self.range = MissionParameterRange(min: 50, max: 150, step: 1, defaultValue: id.defaultValue)
            case .speed:
                self.range = MissionParameterRange(min: 5, max: 15, step: 1, defaultValue: id.defaultValue)
        }
        self.value = self.range.defaultValue
    }

    func increment() {
        let newValue = value + range.step
        if range.contains(newValue) {
            value = newValue
        }
    }

    func decrement() {
        let newValue = value - range.step
        if range.contains(newValue) {
            value = newValue
        }
    }
}

class MissionParameters {
    // Observer properties
    var meanderStep = MissionParameter(.meanderStep)
    var meanderAngle = MissionParameter(.meanderAngle)
    var altitude = MissionParameter(.altitude)
    var speed = MissionParameter(.speed)
}
