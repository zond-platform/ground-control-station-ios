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
    private var valueButton = UIButton()
    private var decrementButton = UIButton()
    private var incrementButton = UIButton()
    private var stackView = UIStackView()
    var id: MissionParameterId!

    // Notifyer properties
    var parameterValuePressed: (() -> Void)?
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

        valueButton.setTitleColor(UIColor.white, for: .normal)
        valueButton.setTitleColor(Colors.secondary, for: .selected)
        valueButton.titleLabel?.textAlignment = .center
        valueButton.titleLabel?.font = Fonts.title
        updateValueLabel(id, id.defaultValue)

        if id == .crossGrid {
            valueButton.addTarget(self, action: #selector(onValuePressed(_:)), for: .touchUpInside)
        } else {
            decrementButton.setImage(#imageLiteral(resourceName: "buttonMenuDecrement"), for: .normal)
            decrementButton.addTarget(self, action: #selector(onValueDecrementPressed(_:)), for: .touchUpInside)
            incrementButton.setImage(#imageLiteral(resourceName: "buttonMenuIncrement"), for: .normal)
            incrementButton.addTarget(self, action: #selector(onValueIncrementPressed(_:)), for: .touchUpInside)
        }

        stackView.addArrangedSubview(paramNameLabel)
        stackView.addArrangedSubview(decrementButton)
        stackView.addArrangedSubview(valueButton)
        stackView.addArrangedSubview(incrementButton)

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: viewWidth),
            valueButton.widthAnchor.constraint(equalToConstant: parameterValueWidth),
            valueButton.heightAnchor.constraint(equalToConstant: Dimensions.tileSize),
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
    func updateValueLabel(_ id: MissionParameterId, _ value: Float) {
        if id == .crossGrid {
            let enabled = (value != 0.0)
            valueButton.isSelected = enabled
            valueButton.setTitle(enabled ? "On" : "Off", for: .normal)
        } else {
            valueButton.setTitle(String(format: "%.0f", value) + " " + id.unit, for: .normal)
        }
    }
}

// Handle control events
extension ParameterEditView {
    @objc func onValuePressed(_ : UIButton) {
        parameterValuePressed?()
    }

    @objc func onValueDecrementPressed(_ : UIButton) {
        parameterDecrementPressed?()
    }

    @objc func onValueIncrementPressed(_ : UIButton) {
        parameterIncrementPressed?()
    }
}
