//
//  GpsSignalWidget.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 14.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

fileprivate let defaultSatCount = "0"
fileprivate let defaultIndicator = UIImage(#imageLiteral(resourceName: "indicatorSignal0"))

class GpsSignalWidget : UIView {
    // Stored properties
    private let icon = UIImageView(image: UIImage(#imageLiteral(resourceName: "indicatorGps")))
    private let indicator = UIImageView(image: defaultIndicator)
    private let label = UILabel()
    private let stackView = UIStackView()

    // Computed properties
    private var width: CGFloat {
        return Dimensions.telemetryIconSize + Dimensions.telemetrySpacer + Dimensions.telemetryIndicatorWidth
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect())

        label.font = Fonts.indicator
        label.textColor = UIColor.white
        label.text = defaultSatCount
        label.frame = CGRect(
            x: Dimensions.telemetryIconSize + Dimensions.telemetrySpacer,
            y: 0,
            width: Fonts.indicator.pointSize * CGFloat(2),
            height: Fonts.indicator.pointSize
        )

        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .bottom

        stackView.addArrangedSubview(icon)
        stackView.setCustomSpacing(Dimensions.telemetrySpacer, after: icon)
        stackView.addArrangedSubview(indicator)

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)
        addSubview(label)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: Dimensions.telemetryIconSize),
            icon.heightAnchor.constraint(equalToConstant: Dimensions.telemetryIconSize),
            icon.widthAnchor.constraint(equalToConstant: Dimensions.telemetryIconSize),
            indicator.heightAnchor.constraint(equalToConstant: Dimensions.telemetryIndicatorWidth),
            indicator.widthAnchor.constraint(equalToConstant: Dimensions.telemetryIndicatorWidth)
        ])
    }
}

// Public methods
extension GpsSignalWidget {
    func update(signalStatus: UInt?) {
        if let status = signalStatus {
            switch status {
            case 0:
                indicator.image = #imageLiteral(resourceName: "indicatorSignal1")
            case 1:
                indicator.image = #imageLiteral(resourceName: "indicatorSignal2")
            case 2:
                fallthrough
            case 3:
                indicator.image = #imageLiteral(resourceName: "indicatorSignal3")
            case 4:
                indicator.image = #imageLiteral(resourceName: "indicatorSignal4")
            case 5:
                indicator.image = #imageLiteral(resourceName: "indicatorSignal5")
            default:
                indicator.image = defaultIndicator
            }
        } else {
            indicator.image = defaultIndicator
        }
    }

    func update(satCount: UInt?) {
        label.text = satCount != nil ? String(satCount!) : defaultSatCount
    }
}
