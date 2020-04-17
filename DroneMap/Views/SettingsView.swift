//
//  SettingsView.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 5/25/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

class SettingsView : UIView {
    private var stackView = UIStackView()
    private var tabView = UIButton()
    var tableView = UITableView(frame: CGRect(), style: .grouped)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: CGRect(
            x: AppDimensions.SettingsView.x,
            y: AppDimensions.SettingsView.y,
            width: AppDimensions.SettingsView.width,
            height: AppDimensions.SettingsView.height
        ))
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center

        tabView.backgroundColor = UIColor.white
        tabView.setTitle("Menu", for: .normal)
        tabView.setTitleColor(.black, for: .normal)
        tabView.titleLabel!.font = AppFont.largeFont
        tabView.layer.cornerRadius = AppDimensions.SettingsView.Tab.radius
        tabView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabView.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)
        tabView.heightAnchor.constraint(equalToConstant: AppDimensions.SettingsView.Tab.height).isActive = true
        tabView.widthAnchor.constraint(equalToConstant: AppDimensions.SettingsView.width).isActive = true
        stackView.addArrangedSubview(tabView)

        tableView.separatorStyle = .none
        tableView.heightAnchor.constraint(equalToConstant: AppDimensions.SettingsView.Table.height).isActive = true
        tableView.widthAnchor.constraint(equalToConstant: AppDimensions.SettingsView.width).isActive = true
        stackView.addArrangedSubview(tableView)

        stackView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        dropShadow()
    }
}

// Private methods
extension SettingsView {
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowOffset = .zero
        layer.shadowRadius = 4
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}

// Handle control events
extension SettingsView {
    @objc func onButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        UIView.animate(withDuration: 0.5, animations: {
            if sender.isSelected {
                self.frame.origin.y += AppDimensions.SettingsView.Table.height
            } else {
                self.frame.origin.y -= AppDimensions.SettingsView.Table.height
            }
        })
    }
}
