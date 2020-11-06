//
//  BatteryWidget.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 13.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

fileprivate let defaultValue = "N/A"
fileprivate let defaultIcon = UIImage(#imageLiteral(resourceName: "indicatorBattery3"))

fileprivate let width = Dimensions.telemetryIconSize +
                        Dimensions.telemetrySpacer +
                        Dimensions.staticTelemetryLabelWidth

class BatteryWidget : UIView {
    private let icon = UIImageView(image: defaultIcon)
    private let label = UILabel()
    private let stackView = UIStackView()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect())

        label.font = Fonts.title
        label.textColor = UIColor.white
        label.text = defaultValue
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .bottom

        stackView.addArrangedSubview(icon)
        stackView.setCustomSpacing(Dimensions.telemetrySpacer, after: icon)
        stackView.addArrangedSubview(label)

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: Dimensions.telemetryIconSize),
            icon.heightAnchor.constraint(equalToConstant: Dimensions.telemetryIconSize),
            icon.widthAnchor.constraint(equalToConstant: Dimensions.telemetryIconSize),
            label.widthAnchor.constraint(equalToConstant: Dimensions.staticTelemetryLabelWidth),
            label.heightAnchor.constraint(equalToConstant: Fonts.title.pointSize)
        ])
    }
}

// Public methods
extension BatteryWidget {
    func update(_ batteryPercentage: UInt?) {
        if let batteryPercentage = batteryPercentage {
            label.text = String(batteryPercentage) + "%"
            if batteryPercentage > 0 && batteryPercentage <= 30 {
                label.textColor = Colors.error
                icon.image = #imageLiteral(resourceName: "indicatorBattery1")
            } else if batteryPercentage > 30 && batteryPercentage <= 60 {
                label.textColor = Colors.warning
                icon.image = #imageLiteral(resourceName: "indicatorBattery2")
            } else if batteryPercentage > 60 && batteryPercentage <= 80 {
                label.textColor = Colors.success
                icon.image = #imageLiteral(resourceName: "indicatorBattery2")
            } else {
                label.textColor = Colors.success
                icon.image = #imageLiteral(resourceName: "indicatorBattery3")
            }
        } else {
            label.text = defaultValue
            label.textColor = UIColor.white
            icon.image = defaultIcon
        }
    }
}
