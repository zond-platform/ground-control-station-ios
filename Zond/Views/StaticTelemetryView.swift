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
    private let flightModeWidget = FlightModeWidget()
    private let gpsSignalWidget = GpsSignalWidget()
    private let linkSignalWidget = LinkSignalWidget()
    private let batteryWidget = BatteryWidget()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect())

        backgroundColor = Colors.primary

        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.layoutMargins = UIEdgeInsets(
            top: 0,
            left: Dimensions.spacer,
            bottom: 0,
            right: Dimensions.spacer
        )

        stackView.addArrangedSubview(flightModeWidget)
        stackView.setCustomSpacing(Dimensions.spacer, after: flightModeWidget)
        stackView.addArrangedSubview(gpsSignalWidget)
        stackView.setCustomSpacing(Dimensions.spacer, after: gpsSignalWidget)
        stackView.addArrangedSubview(linkSignalWidget)
        stackView.setCustomSpacing(Dimensions.spacer, after: linkSignalWidget)
        stackView.addArrangedSubview(batteryWidget)

        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Dimensions.tileSize),
            stackView.widthAnchor.constraint(equalTo: widthAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// Public methods
extension StaticTelemetryView {
    func updateFlightMode(_ modeString: String?) {
        flightModeWidget.update(modeString)
    }

    func updateGpsSignalStatus(_ signalStatus: UInt?) {
        gpsSignalWidget.update(signalStatus: signalStatus)
    }

    func updateGpsSatCount(_ satCount: UInt?) {
        gpsSignalWidget.update(satCount: satCount)
    }

    func updateLinkSignalStrength(_ signalStrength: UInt?) {
        linkSignalWidget.update(signalStrength)
    }

    func updateBatteryPercentage(_ batteryPercentage: UInt?) {
        batteryWidget.update(batteryPercentage)
    }
}
