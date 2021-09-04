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
                return "N/A"
            case .altitude:
                fallthrough
            case .distance:
                return "N/A"
        }
    }
}

class DynamicTelemetryWidget : UIView {
    private(set) var id: DynamicTelemetryWidgetId!
    private let stackView = UIStackView()
    private var titleLabel = UILabel()
    private var valueLabel = UILabel()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ id: DynamicTelemetryWidgetId) {
        super.init(frame: CGRect())
        self.id = id

        backgroundColor = Colors.primary

        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .bottom

        stackView.addArrangedSubview(titleLabel)
        stackView.setCustomSpacing(Dimensions.separator, after: titleLabel)
        stackView.addArrangedSubview(valueLabel)

        titleLabel.text = id.title + ":"
        titleLabel.textAlignment = .right
        titleLabel.font = Fonts.telemetryLabel
        valueLabel.font = Fonts.telemetryValue
        titleLabel.textColor = .white
        valueLabel.textColor = .white
        updateValueLabel(nil)

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)

        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: Dimensions.tileSize),
            valueLabel.heightAnchor.constraint(equalToConstant: Fonts.telemetryValue.pointSize),
            widthAnchor.constraint(equalToConstant: Dimensions.dynamicTelemetryWidgetWidth),
            heightAnchor.constraint(equalToConstant: Dimensions.tileSize),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// Public methods
extension DynamicTelemetryWidget {
    func updateValueLabel(_ telemetryData: String?) {
        if let data = telemetryData {
            valueLabel.text = data + " " + id.unit
        } else {
            valueLabel.text = id.defaultValue
        }
    }
}
