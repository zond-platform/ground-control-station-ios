//
//  LinkSignalWidget.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 14.10.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class LinkSignalWidget : UIView {
    // Stored properties
    private let icon = UIImageView(image: UIImage(#imageLiteral(resourceName: "indicatorRemote")))
    private let indicator = UIImageView(image: UIImage(#imageLiteral(resourceName: "indicatorSignal5")))
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
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .bottom

        stackView.addArrangedSubview(icon)
        stackView.setCustomSpacing(Dimensions.telemetrySpacer, after: icon)
        stackView.addArrangedSubview(indicator)

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)

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
extension LinkSignalWidget {
    func update(_ signalStrength: UInt?) {
//        label.text = value == nil ? 0 : value!
    }
}
