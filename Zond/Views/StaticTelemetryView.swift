//
//  StaticTelemetryView.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 23.05.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class StaticTelemetryView : UIView {
    private var stackView = UIStackView()
    private var labels: [TelemetryDataId:StaticTelemetryLabel] = [:]

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect())

        backgroundColor = Colors.Overlay.primaryColor

        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center

        for id in [TelemetryDataId.batteryCharge, TelemetryDataId.gpsSatellite, TelemetryDataId.flightMode] {
            labels[id] = StaticTelemetryLabel(id)
            labels[id]!.updateText(nil)
            stackView.addArrangedSubview(labels[id]!)
        }

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Dimensions.tileSize),
            stackView.widthAnchor.constraint(equalTo: widthAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// Public methods
extension StaticTelemetryView {
    func updateData(_ id: TelemetryDataId, _ value: String?) {
        if let label = labels[id] {
            label.updateText(value)
        }
    }
}
