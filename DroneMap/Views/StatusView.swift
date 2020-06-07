//
//  StatusView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 23.05.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

fileprivate let displayExceptionList: [TelemetryDataId] = [
    .gpsSignal
]

class StatusView : UIView {
    // Stored properties
    private var stackView = UIStackView()
    private var labels: [StatusLabel] = []

    // Computed properties
    private var width: CGFloat {
        return Dimensions.ContentView.width * (Dimensions.ContentView.Ratio.h[0] + Dimensions.ContentView.Ratio.h[1])
               - Dimensions.viewSpacer
    }
    private var height: CGFloat {
        return Dimensions.ContentView.height * Dimensions.ContentView.Ratio.v[0]
    }
    private var labelWidth: CGFloat {
        return width / CGFloat(TelemetryDataId.allCases.count)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect())
        frame = CGRect(
            x: Dimensions.ContentView.x,
            y: Dimensions.ContentView.y,
            width: width,
            height: height
        )

        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .firstBaseline

        for id in TelemetryDataId.allCases {
            if displayExceptionList.contains(id) {
                continue
            } else {
                labels.append(StatusLabel(id))
                labels.last!.updateText(nil)
                NSLayoutConstraint.activate([
                    labels.last!.heightAnchor.constraint(equalToConstant: height),
                    labels.last!.widthAnchor.constraint(equalToConstant: labelWidth)
                ])
                stackView.addArrangedSubview(labels.last!)
            }
        }

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)
    }
}

// Public methods
extension StatusView {
    func updateData(_ id: TelemetryDataId, _ value: String?) {
        for i in 0..<labels.count {
            if labels[i].id == id {
                labels[i].updateText(value)
            }
        }
    }
}
