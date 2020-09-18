//
//  TableViewButtonCell.swift
//  Zond
//
//  Created by Evgeny Agamirzov on 27.04.20.
//  Copyright © 2020 Evgeny Agamirzov. All rights reserved.
//

import UIKit

fileprivate let missionStateMap: [MissionState:[CommandButtonId]] = [
    .uploaded : [CommandButtonId.importJson, CommandButtonId.edit,   CommandButtonId.start,  CommandButtonId.stop],
    .running  : [CommandButtonId.importJson, CommandButtonId.edit,   CommandButtonId.pause,  CommandButtonId.stop],
    .paused   : [CommandButtonId.importJson, CommandButtonId.edit,   CommandButtonId.resume, CommandButtonId.stop],
    .editing  : [CommandButtonId.importJson, CommandButtonId.upload, CommandButtonId.start,  CommandButtonId.stop],
]

class TableCommandCell : UITableViewCell {
    // Stored properties
    private let stackView = UIStackView()
    private var buttons: [CommandButton] = []

    // Notifyer properties
    var buttonPressed: ((_ id: CommandButtonId) -> Void)?

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
        stackView.spacing = Dimensions.textSpacer
        stackView.layoutMargins = UIEdgeInsets(
            top: 0.0,
            left: Dimensions.textSpacer,
            bottom: 0.0,
            right: Dimensions.textSpacer
        )
        stackView.isLayoutMarginsRelativeArrangement = true

        for id in missionStateMap[.editing]! {
            buttons.append(CommandButton(id))
            buttons.last!.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)
            NSLayoutConstraint.activate([
                buttons.last!.heightAnchor.constraint(equalToConstant: MissionView.TableRow.height)
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
extension TableCommandCell {
    func updateData(_ row: RowData<Any>) {
        let id = row.value as! MissionState
        for i in 0..<buttons.count {
            buttons[i].id = missionStateMap[id]![i]
        }
        if row.isEnabled {
            switch id {
                case .editing:
                    enable(buttons: [buttons[0], buttons[1]], true)
                    enable(buttons: [buttons[2], buttons[3]], false)
                case .uploaded:
                    enable(buttons: [buttons[0]], false)
                    enable(buttons: [buttons[1], buttons[2], buttons[3]], true)
                case .running:
                    fallthrough
                case .paused:
                    enable(buttons: [buttons[0], buttons[1]], false)
                    enable(buttons: [buttons[2], buttons[3]], true)
            }
        } else {
            enable(buttons: [buttons[0]], true)
            enable(buttons: [buttons[1], buttons[2], buttons[3]], false)
        }
    }
}

// Private methods
extension TableCommandCell {
    func enable(buttons: [CommandButton], _ enable: Bool) {
        for i in 0..<buttons.count {
            buttons[i].isEnabled = enable
        }
    }
}

// Handle control events
extension TableCommandCell {
    @objc func onButtonPressed(_ sender: CommandButton) {
        buttonPressed?(sender.id)
    }
}
