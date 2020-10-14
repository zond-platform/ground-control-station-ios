//
//  TableButtonsCell.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 27.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

enum TableButtonId {
    case importJson
    case upload

    var title: String {
        switch self {
            case .importJson:
                return "Import"
            case .upload:
                return "Upload"
        }
    }
}

extension TableButtonId : CaseIterable {}

class TableButtonsCell : UITableViewCell {
    // Stored properties
    private let stackView = UIStackView()
    private var buttons: [TableButton] = []

    // Notifyer properties
    var buttonPressed: ((_ id: TableButtonId) -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        accessoryType = .none
        backgroundColor = .clear

        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = Dimensions.spacer
        stackView.layoutMargins = UIEdgeInsets(
            top: 0.0,
            left: Dimensions.spacer,
            bottom: 0.0,
            right: Dimensions.spacer
        )
        stackView.isLayoutMarginsRelativeArrangement = true

        for id in TableButtonId.allCases {
            buttons.append(TableButton(id))
            buttons.last!.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)
            NSLayoutConstraint.activate([
                buttons.last!.heightAnchor.constraint(equalToConstant: Dimensions.tileSize)
            ])
            stackView.addArrangedSubview(buttons.last!)
        }

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// Public methods
extension TableButtonsCell {
    func updateData(_ row: RowData<Any>) {
        if let i = buttons.firstIndex(where: { $0.id != nil && $0.id == .upload }) {
            buttons[i].isEnabled = row.isEnabled
        }
    }
}

// Handle control events
extension TableButtonsCell {
    @objc func onButtonPressed(_ sender: TableButton) {
        if let id = sender.id {
            buttonPressed?(id)
        }
    }
}
