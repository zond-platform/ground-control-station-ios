//
//  SettingsViewController.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/6/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

fileprivate var settingsData = [
    SettingsSection(id: .simulator,
                    entries: [SettingsCell(id: .simulator,  type: .switcher, enabled: false,  value: false)]),
    SettingsSection(id: .mission,
                    entries: [SettingsCell(id: .edit,       type: .switcher, enabled: true,  value: false),
                              SettingsCell(id: .altitude,   type: .slider,   enabled: false, value: 0.0),
                              SettingsCell(id: .distance,   type: .slider,   enabled: false, value: 0.0),
                              SettingsCell(id: .upload,     type: .button,   enabled: false, value: false)]),
    SettingsSection(id: .status,
                    entries: [SettingsCell(id: .model,      type: .info,     enabled: true,  value: "-"),
                              SettingsCell(id: .mode,       type: .info,     enabled: true,  value: "-"),
                              SettingsCell(id: .altitude,   type: .info,     enabled: true,  value: "-"),
                              SettingsCell(id: .battery,    type: .info,     enabled: true,  value: "-"),
                              SettingsCell(id: .signal,     type: .info,     enabled: true,  value: "-"),
                              SettingsCell(id: .satellites, type: .info,     enabled: true,  value: "-")])
]

class SettingsViewController : UIViewController {
    private var settingsView: SettingsView!
    private var dataSource: SettingsDataSource!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        settingsView = SettingsView()
        settingsView.addDelegate(self)
        dataSource = SettingsDataSource(settingsView, settingsData)
        settingsView.tableView.dataSource = self.dataSource
        settingsView.tableView.delegate = self.dataSource
        view = settingsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// Public methods
extension SettingsViewController {
    func showView(_ show: Bool) {
        settingsView.show(show)
    }
}

// Handle view updates
extension SettingsViewController : SettingsViewDelegate {
    internal func animationCompleted() {}
}
