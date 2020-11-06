//
//  MissionView.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 5/25/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

fileprivate let x = CGFloat(0)
fileprivate let y = CGFloat(0)
fileprivate let width = Dimensions.missionMenuWidth
fileprivate let height = Dimensions.screenHeight

class MissionView : UIView {
    // Stored properties
    private let cancelButton = UIButton()
    private let stackView = UIStackView()

    // Notifyer properties
    var cancelButtonPressed: (() -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect(
            x: -width,
            y: y,
            width: width,
            height: height
        ))

        backgroundColor = Colors.primary

        cancelButton.addTarget(self, action: #selector(onCancelButtonPressed(_:)), for: .touchUpInside)
        cancelButton.setImage(#imageLiteral(resourceName: "buttonCancel"), for: .normal)

        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading

        stackView.addArrangedSubview(cancelButton)
        stackView.setCustomSpacing(Dimensions.doubleSpacer, after: cancelButton)
        stackView.addArrangedSubview(Environment.parametersViewController.view)
        stackView.setCustomSpacing(Dimensions.doubleSpacer, after: Environment.parametersViewController.view)
        stackView.addArrangedSubview(Environment.importExportViewController.view)

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)

        NSLayoutConstraint.activate([
            cancelButton.widthAnchor.constraint(equalToConstant: Dimensions.tileSize),
            cancelButton.heightAnchor.constraint(equalToConstant: Dimensions.tileSize),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimensions.safeAreaOffset + Dimensions.doubleSpacer),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Dimensions.doubleSpacer),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Dimensions.doubleSpacer),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Dimensions.doubleSpacer)
        ])
    }
}

// Public methods
extension MissionView {
    func toggleShowFromSide(_ show: Bool) {
        self.frame.origin.x = show ? x : -width
    }
}

// Handle control events
extension MissionView {
    @objc func onCancelButtonPressed(_: UIButton) {
        cancelButtonPressed?()
    }
}
