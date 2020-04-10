//
//  SettingsViewController.swift
//  DroneMap
//
//  Created by Evgeny Agamirzov on 4/6/19.
//  Copyright © 2019 Evgeny Agamirzov. All rights reserved.
//

import UIKit

fileprivate var settingsData = [
    SettingsSectionData(id: .simulator,
                        entries: [SettingsCellData(id: .simulator,  type: .switcher, enabled: false,  value: false)]),
    SettingsSectionData(id: .mission,
                        entries: [SettingsCellData(id: .edit,       type: .switcher, enabled: true,  value: false),
                                  SettingsCellData(id: .altitude,   type: .slider,   enabled: false, value: 0.0),
                                  SettingsCellData(id: .distance,   type: .slider,   enabled: false, value: 0.0),
                                  SettingsCellData(id: .upload,     type: .button,   enabled: false, value: false)]),
    SettingsSectionData(id: .status,
                        entries: [SettingsCellData(id: .model,      type: .info,     enabled: true,  value: "-"),
                                  SettingsCellData(id: .mode,       type: .info,     enabled: true,  value: "-"),
                                  SettingsCellData(id: .altitude,   type: .info,     enabled: true,  value: "-"),
                                  SettingsCellData(id: .battery,    type: .info,     enabled: true,  value: "-"),
                                  SettingsCellData(id: .signal,     type: .info,     enabled: true,  value: "-"),
                                  SettingsCellData(id: .satellites, type: .info,     enabled: true,  value: "-")])
]

class SettingsViewController : UIViewController {
    private var settingsView: SettingsView!
    private var dataSource: SettingsViewDataSource!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ env: Environment) {
        super.init(nibName: nil, bundle: nil)

        settingsView = SettingsView()
        dataSource = SettingsViewDataSource(env, settingsView, settingsData)
        settingsView.dataSource = dataSource
        view = settingsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// Subscribe to table view updates
extension SettingsViewController : UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, heightForRowAt: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
