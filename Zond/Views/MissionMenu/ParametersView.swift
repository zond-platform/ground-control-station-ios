//
//  ParametersView.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 17.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class ParametersView : UIView {
    // Stored properties
    private var parameterEditViews: [ParameterEditView] = []
    private let stackView = UIStackView()

    // Notifyer properties
    var parameterIncrementPressed: ((_ id: MissionParameterId) -> Void)?
    var parameterDecrementPressed: ((_ id: MissionParameterId) -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect())

        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading

        for parameterId in MissionParameterId.allCases {
            parameterEditViews.append(ParameterEditView(parameterId))
            stackView.addArrangedSubview(parameterEditViews.last!)
        }

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)

        registerListeners()

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: Dimensions.missionMenuWidth)
        ])
    }
}

// Public methods
extension ParametersView {
    func registerListeners() {
        for i in 0..<parameterEditViews.count {
            parameterEditViews[i].parameterDecrementPressed = {
                self.parameterDecrementPressed?(self.parameterEditViews[i].id)
            }
            parameterEditViews[i].parameterIncrementPressed = {
                self.parameterIncrementPressed?(self.parameterEditViews[i].id)
            }
        }
    }

    func updateValueLabel(for id: MissionParameterId, with value: Float) {
        let index = parameterEditViews.firstIndex(where: { $0.id == id })!
        parameterEditViews[index].updateValueLabel(value)
    }
}
