//
//  RootView.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 4/25/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class RootView : UIView {
    private let stackView = UIStackView()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect(
            x: 0,
            y: 0,
            width: Dimensions.screenWidth,
            height: Dimensions.screenHeight
        ))

        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center

        stackView.addArrangedSubview(Environment.statusViewController.view)
        stackView.setCustomSpacing(Dimensions.viewDivider, after: Environment.statusViewController.view)
        stackView.addArrangedSubview(Environment.missionViewController.view)
        stackView.translatesAutoresizingMaskIntoConstraints = false;

        addSubview(Environment.mapViewController.view)
        addSubview(stackView)

//        addSubview(Environment.missionViewController.view)
//        addSubview(Environment.navigationViewController.view)
    }
}
