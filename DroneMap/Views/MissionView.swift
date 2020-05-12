//
//  MissionView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 5/25/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class MissionView : UIView {
    private var verticalStackView = UIStackView()
    private var button = UIButton()
    var tableView = UITableView(frame: CGRect(), style: .grouped)
    var buttonSelected: ((_ isSelected: Bool) -> Void)?

    private var buttonHeight = AppDimensions.MissionView.Row.height
    private var tableHeight = CGFloat(0)

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ tableHeight: CGFloat) {
        super.init(frame: CGRect(
            x: AppDimensions.MissionView.x,
            y: AppDimensions.MissionView.y,
            width: AppDimensions.MissionView.width,
            height: buttonHeight
        ))

        self.tableHeight = tableHeight

        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fill
        verticalStackView.alignment = .top

        button.isSelected = false
        button.backgroundColor = AppColor.primaryColor
        button.setTitleColor(AppColor.Text.mainTitle, for: .normal)
        button.setTitleColor(AppColor.secondaryColor, for: .selected)
        button.setTitle("Mission", for: .normal)
        button.titleLabel?.font = AppFont.smallFont
        button.addTarget(self, action: #selector(buttonSelected(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: AppDimensions.MissionView.width),
            button.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
        verticalStackView.addArrangedSubview(button)

        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.backgroundColor = AppColor.primaryColor
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalToConstant: AppDimensions.MissionView.width)
        ])
        verticalStackView.addArrangedSubview(tableView)

        verticalStackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(verticalStackView)
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// Public methods
extension MissionView {
    func showMissionEditor(_ show: Bool) {
        UIView.animate(withDuration: 0.0, animations: {
            if show {
                self.frame.size.height = self.buttonHeight + self.tableHeight
            } else {
                self.frame.size.height = self.buttonHeight
            }
        })
    }
}

// Handle control events
extension MissionView {
    @objc func buttonSelected(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        buttonSelected?(sender.isSelected)
    }
}
