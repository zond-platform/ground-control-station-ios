//
//  ParameterEditView.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 16.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

fileprivate let viewWidth = Dimensions.missionMenuWidth - Dimensions.roundedAreaOffsetOr(0)
fileprivate let parameterValueWidth = Dimensions.tileSize * CGFloat(2)

class ParameterEditView : UIView {
    // Stored properties
    private var paramNameLabel = UILabel()
    private var valueLabel = UILabel()
    private var decrementButton = UIButton()
    private var incrementButton = UIButton()
    private var stackView = UIStackView()
    var id: MissionParameterId!

    // Notifyer properties
    var parameterIncrementPressed: (() -> Void)?
    var parameterDecrementPressed: (() -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ id: MissionParameterId) {
        super.init(frame: CGRect())

        self.id = id

        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center

        paramNameLabel.text = id.name
        paramNameLabel.textColor = UIColor.white
        paramNameLabel.font = Fonts.title

        valueLabel.textColor = UIColor.white
        valueLabel.textAlignment = .center
        valueLabel.font = Fonts.title
        updateValueLabel(id.defaultValue)

        decrementButton.setImage(#imageLiteral(resourceName: "buttonMenuDecrement"), for: .normal)
        decrementButton.addTarget(self, action: #selector(onValueDecrementPressed(_:)), for: .touchUpInside)
        incrementButton.setImage(#imageLiteral(resourceName: "buttonMenuIncrement"), for: .normal)
        incrementButton.addTarget(self, action: #selector(onValueIncrementPressed(_:)), for: .touchUpInside)

        stackView.addArrangedSubview(paramNameLabel)
        stackView.addArrangedSubview(decrementButton)
        stackView.addArrangedSubview(valueLabel)
        stackView.addArrangedSubview(incrementButton)

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: viewWidth),
            valueLabel.widthAnchor.constraint(equalToConstant: parameterValueWidth),
            valueLabel.heightAnchor.constraint(equalToConstant: Dimensions.tileSize),
            decrementButton.heightAnchor.constraint(equalToConstant: Dimensions.tileSize),
            decrementButton.widthAnchor.constraint(equalToConstant: Dimensions.tileSize),
            incrementButton.heightAnchor.constraint(equalToConstant: Dimensions.tileSize),
            incrementButton.widthAnchor.constraint(equalToConstant: Dimensions.tileSize),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimensions.spacer),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Dimensions.spacer),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// Public methods
extension ParameterEditView {
    func updateValueLabel(_ value: Float) {
        valueLabel.text = String(format: "%.0f", value) + " " + id.unit
    }
}

// Handle control events
extension ParameterEditView {
    @objc func onValueDecrementPressed(_ : UIButton) {
        parameterDecrementPressed?()
    }

    @objc func onValueIncrementPressed(_ : UIButton) {
        parameterIncrementPressed?()
    }
}
