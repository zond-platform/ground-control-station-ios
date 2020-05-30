//
//  MissionView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 5/25/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class MissionView : UIView {
    // Static properties
    static let width = Dimensions.ContentView.width * Dimensions.ContentView.Ratio.h[0]
    struct TableRow {
        static let height = Dimensions.ContentView.height * Dimensions.ContentView.Ratio.v[0]
    }
    struct TableSection {
        struct Editor {
            static let headerHeight = CGFloat(0.0)
            static let footerHeight = TableRow.height * CGFloat(0.5)
        }
        struct Command {
            static let headerHeight = TableRow.height * CGFloat(0.5)
            static let footerHeight = TableRow.height * CGFloat(0.5)
        }
    }

    // Stored properties
    var tableView = UITableView(frame: CGRect(), style: .grouped)
    private var stackView = UIStackView()
    private var button = UIButton()
    private var buttonHeight = MissionView.TableRow.height
    private var tableHeight = CGFloat(0)

    // Computed properties
    var isButtonSelected: Bool {
        return button.isSelected
    }
    private var yOffset: CGFloat {
        return Dimensions.ContentView.height * Dimensions.ContentView.Ratio.v[1]
    }

    // Notifyer properties
    var missionModeToggled: (() -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ tableHeight: CGFloat) {
        super.init(frame: CGRect())
        frame = CGRect(
            x: Dimensions.ContentView.x,
            y: Dimensions.ContentView.y + yOffset,
            width: MissionView.width,
            height: buttonHeight + tableHeight
        )

        self.tableHeight = tableHeight

        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .top

        button.isSelected = false
        button.backgroundColor = Colors.Overlay.primaryColor
        button.setTitle("Mission", for: .normal)
        button.titleLabel?.font = Fonts.titleFont
        button.addTarget(self, action: #selector(buttonSelected(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: MissionView.width),
            button.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
        stackView.addArrangedSubview(button)

        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.backgroundColor = Colors.Overlay.primaryColor
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalToConstant: MissionView.width)
        ])
        stackView.addArrangedSubview(tableView)

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// Public methods
extension MissionView {
    func expand(for state: MissionState?) {
        UIView.animate(withDuration: 0.3, animations: {
            if state == nil {
                self.frame.origin.y = Dimensions.ContentView.y
                                      + self.yOffset
            } else if state! == .disconnected || state! == .finished {
                self.frame.origin.y = Dimensions.ContentView.y
                                      + self.yOffset
                                      - self.tableHeight
                                      + Dimensions.viewSpacer
            } else {
                self.frame.origin.y = Dimensions.ContentView.y
                                      + self.yOffset
                                      - TableRow.height
                                      - TableSection.Command.footerHeight
            }
        })
    }
}

// Handle control events
extension MissionView {
    @objc func buttonSelected(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        missionModeToggled?()
    }
}
