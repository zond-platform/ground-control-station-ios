//
//  ParametersViewController.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 17.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class ParametersViewController : UIViewController {
    private var parametersView: ParametersView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        parametersView = ParametersView()
        registerListeners()
        view = parametersView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// Private methods
extension ParametersViewController {
    private func registerListeners() {
        parametersView.parameterDecrementPressed = { id in
            switch id {
                case .meanderStep:
                    Environment.missionParameters.meanderStep.decrement()
                case .meanderAngle:
                    Environment.missionParameters.meanderAngle.decrement()
                case .altitude:
                    Environment.missionParameters.altitude.decrement()
                case .speed:
                    Environment.missionParameters.speed.decrement()
                default:
                    ()
            }
        }
        parametersView.parameterIncrementPressed = { id in
            switch id {
                case .meanderStep:
                    return Environment.missionParameters.meanderStep.increment()
                case .meanderAngle:
                    return Environment.missionParameters.meanderAngle.increment()
                case .altitude:
                    return Environment.missionParameters.altitude.increment()
                case .speed:
                    return Environment.missionParameters.speed.increment()
                default:
                    ()
            }
        }
        parametersView.parameterValuePressed = { id in
            switch id {
                case .crossGrid:
                    return Environment.missionParameters.crossGrid.increment()
                default:
                    ()
            }
        }
        Environment.missionParameters.meanderStep.valueListeners.append({ value in
            self.parametersView.updateValueLabel(for: .meanderStep, with: value)
        })
        Environment.missionParameters.meanderAngle.valueListeners.append({ value in
            self.parametersView.updateValueLabel(for: .meanderAngle, with: value)
        })
        Environment.missionParameters.altitude.valueListeners.append({ value in
            self.parametersView.updateValueLabel(for: .altitude, with: value)
        })
        Environment.missionParameters.speed.valueListeners.append({ value in
            self.parametersView.updateValueLabel(for: .speed, with: value)
        })
        Environment.missionParameters.crossGrid.valueListeners.append({ value in
            self.parametersView.updateValueLabel(for: .crossGrid, with: value)
        })
    }
}
