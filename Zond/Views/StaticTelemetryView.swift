//
//  StaticTelemetryView.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 23.05.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class StaticTelemetryView : UIView {
    // Stored properties
    private let stackView = UIStackView()
    private let flightModeWidget = FlightModeWidget()
    private let gpsSignalWidget = GpsSignalWidget()
    private let linkSignalWidget = LinkSignalWidget()
    private let batteryWidget = BatteryWidget()
    private let simulatorButton = UIButton()

    // Computed properties
    private var doubleSpacer: CGFloat {
        return Dimensions.spacer * CGFloat(2)
    }

    // Notifyer properties
    var simulatorButtonSelected: ((_ isSelected: Bool) -> Void)?

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
            left: doubleSpacer,
            bottom: 0,
            right: doubleSpacer
        )

        simulatorButton.addTarget(self, action: #selector(onSimulatorButtonSelected(_:)), for: .touchUpInside)
        simulatorButton.frame = CGRect(
            x: doubleSpacer,
            y: 0,
            width: flightModeWidget.width,
            height: Dimensions.tileSize
        )

        stackView.addArrangedSubview(flightModeWidget)
        stackView.setCustomSpacing(Dimensions.spacer, after: flightModeWidget)
        stackView.addArrangedSubview(gpsSignalWidget)
        stackView.setCustomSpacing(doubleSpacer, after: gpsSignalWidget)
        stackView.addArrangedSubview(linkSignalWidget)
        stackView.setCustomSpacing(doubleSpacer, after: linkSignalWidget)
        stackView.addArrangedSubview(batteryWidget)

        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)
        addSubview(simulatorButton)

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
        flightModeWidget.update(modeString: modeString)
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

// Public methods
extension StaticTelemetryView {
    func enableSimulatorVisualization(_ enable: Bool) {
        simulatorButton.isSelected = enable
        flightModeWidget.update(isSimulatorOn: enable)
    }
}

// Handle control events
extension StaticTelemetryView {
    @objc func onSimulatorButtonSelected(_: UIButton) {
        simulatorButtonSelected?(!simulatorButton.isSelected)
    }
}
