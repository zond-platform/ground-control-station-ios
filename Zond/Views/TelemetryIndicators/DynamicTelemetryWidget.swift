//
//  DynamicTelemetryWidget.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 30.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum DynamicTelemetryWidgetId: Int {
    case horizontalSpeed
    case verticalSpeed
    case altitude
    case distance

    var title: String {
        switch self {
            case .horizontalSpeed:
                return "HS"
            case .verticalSpeed:
                return "VS"
            case .altitude:
                return "A"
            case .distance:
                return "D"
        }
    }

    var unit: String {
        switch self {
            case .horizontalSpeed:
                fallthrough
            case .verticalSpeed:
                return "m/s"
            case .altitude:
                fallthrough
            case .distance:
                return "m"
        }
    }

    var defaultValue: String {
        switch self {
            case .horizontalSpeed:
                fallthrough
            case .verticalSpeed:
                return "0.0"
            case .altitude:
                fallthrough
            case .distance:
                return "0"
        }
    }
}

class DynamicTelemetryWidget : UIView {
    private(set) var id: DynamicTelemetryWidgetId!
    private let stackView = UIStackView()
    private var titleLabel = DynamicTelemetryLabel()
    private var valueLabel = DynamicTelemetryLabel()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ id: DynamicTelemetryWidgetId) {
        super.init(frame: CGRect())
        self.id = id

        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center

        stackView.addArrangedSubview(titleLabel)
        stackView.setCustomSpacing(Dimensions.spacer, after: titleLabel)
        stackView.addArrangedSubview(valueLabel)

        titleLabel.text = id.title + ":"
        titleLabel.textAlignment = .right
        updateValueLabel(nil)

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)

        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: Dimensions.tileSize),
            widthAnchor.constraint(equalToConstant: Dimensions.dynamicTelemetryWidgetWidth),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// Public methods
extension DynamicTelemetryWidget {
    func updateValueLabel(_ temetryData: String?) {
        valueLabel.text = (temetryData ?? id.defaultValue) + " " + id.unit
    }
}
