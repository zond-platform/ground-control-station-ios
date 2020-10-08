//
//  LocatorView.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 14.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum LocatorButtonId: Int {
    case user
    case aircraft

    var image: UIImage {
        switch self {
            case .user:
                return #imageLiteral(resourceName: "userBtn")
            case .aircraft:
                return #imageLiteral(resourceName: "aircraftBtn")
        }
    }

    var selectedColor: UIColor {
        switch self {
            case .user:
                return Colors.Overlay.userLocationColor
            case .aircraft:
                return Colors.Overlay.aircraftLocationColor
        }
    }
}

extension LocatorButtonId : CaseIterable {}

class LocatorView : UIView {
    // Stored properties
    private let stackView = UIStackView()
    private var buttons: [ImageButton] = []

    // Computed properties
    private var x: CGFloat {
        return Dimensions.screenWidth - Dimensions.tileSize - Dimensions.spacer
    }
    private var y: CGFloat {
        return Dimensions.screenHeight - (Dimensions.tileSize + Dimensions.spacer) * CGFloat(LocatorButtonId.allCases.count)
    }
    private var height: CGFloat {
        return Dimensions.tileSize * CGFloat(LocatorButtonId.allCases.count)
    }

    // Notifyer properties
    var buttonSelected: ((_ id: LocatorButtonId, _ isSelected: Bool) -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect())
        frame = CGRect(
            x: x,
            y: y,
            width: Dimensions.tileSize,
            height: height
        )

        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center

        for id in LocatorButtonId.allCases {
            buttons.append(ImageButton(id.rawValue, id.image, id.selectedColor))
            buttons.last!.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)
            NSLayoutConstraint.activate([
                buttons.last!.heightAnchor.constraint(equalToConstant: Dimensions.tileSize),
                buttons.last!.widthAnchor.constraint(equalToConstant: Dimensions.tileSize)
            ])
            stackView.addArrangedSubview(buttons.last!)
            stackView.setCustomSpacing(Dimensions.spacer, after: buttons.last!)
        }

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)
    }
}

// Public methods
extension LocatorView {
    func deselectButton(with id: LocatorButtonId) {
        if let i = buttons.firstIndex(where: { $0.id != nil && $0.id == id.rawValue }) {
            buttons[i].isSelected = false
        }
    }
}

// Handle control events
extension LocatorView {
    @objc func onButtonPressed(_ sender: ImageButton) {
        sender.isSelected = !sender.isSelected
        if let rawSenderId = sender.id {
            if let senderId = LocatorButtonId(rawValue: rawSenderId) {
                buttonSelected?(senderId, sender.isSelected)
            }
        }
    }
}
